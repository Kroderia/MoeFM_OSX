//
//  LoginWindowController.m
//  MoeFM
//
//  Created by Kroderia on 12/26/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import "LoginWindowController.h"

@interface LoginWindowController ()

@end

@implementation LoginWindowController

@synthesize receiver;

- (void)recvApiData:(id)data {
    [self performSelector:self.todo withObject:data];
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        self.moefmApi = [[MoefmApi alloc] init];
        self.moefmApi.delegate = self;
    }
    return self;
}

- (void)awakeFromNib {
    [self.loadingIndicator startAnimation:nil];
    
    self.todo = @selector(saveRequestTokenAndLoadAuthorizePageOf:);
    [self.moefmApi request];
}

- (void)saveRequestTokenAndLoadAuthorizePageOf: (NSDictionary*)data {
    self.requestToken = [data objectForKey:@"request_token"];
    self.requestTokenSecret = [data objectForKey:@"request_token_secret"];
    self.authorizeUrl = [data objectForKey:@"authorize_url"];
    
    if (self.authorizeUrl == nil) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"加载授权页面失败" defaultButton:@"你没机会的, 只能点我" alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
        [alert runModal];
        [self.window close];
        return;
    }
    
    [self.loginWebView setFrameLoadDelegate:self];
    [[self.loginWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.authorizeUrl]]];
}


- (void)saveAccessTokenAndNotify: (NSDictionary*)data {
    if ([data objectForKey:@"access_token"] == nil) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"加载授权数据失败" defaultButton:@"你没机会的, 只能点我" alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
        [alert runModal];
        [self.window close];
        return;
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[data objectForKey:@"access_token"] forKey:@"accessToken"];
    [ud setObject:[data objectForKey:@"access_token_secret"] forKey:@"accessTokenSecret"];
    
    [self.receiver recvData:nil];
}


- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
    [self.loadingIndicator stopAnimation:nil];
}


- (void)webView:(WebView *)sender didReceiveServerRedirectForProvisionalLoadForFrame:(WebFrame *)frame {
    NSDictionary *parameters = [HttpConnection parseUrlParametersOf:frame.provisionalDataSource.request.URL.query];
    NSString *verifier = [parameters objectForKey:@"verifier"];
    
    if (verifier != nil) {
        [self.loadingIndicator startAnimation:nil];
        [frame stopLoading];
        
        self.todo = @selector(saveAccessTokenAndNotify:);
        [self.moefmApi accessWithRequestToken:self.requestToken
                           RequestTokenSecret:self.requestTokenSecret
                                     Verifier:verifier];
    }
}



@end
