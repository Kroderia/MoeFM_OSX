//
//  LoginWindowController.h
//  MoeFM
//
//  Created by Kroderia on 12/26/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "MoefmApi.h"
#import "MoefmApiDelegate.h"
#import "DataNotifyReceiver.h"
#import "HttpConnection.h"
#import "EasyNotification.h"

@interface LoginWindowController : NSWindowController<MoefmApiDelegate>
{
    SEL todo;
    MoefmApi *moefmApi;
}


@property (weak) IBOutlet WebView *loginWebView;
@property (weak) IBOutlet NSProgressIndicator *loadingIndicator;


@property (strong) NSString *requestToken;
@property (strong) NSString *requestTokenSecret;
@property (strong) NSString *authorizeUrl;
@property (strong) NSString *accessToken;
@property (strong) NSString *accessTokenSecret;

@property (weak) id<DataNotifyReceiver> receiver;

@end
