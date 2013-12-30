//
//  MoefmApi.m
//  MoeFM
//
//  Created by Kroderia on 12/17/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import "MoefmApi.h"
#import "HttpConnection.h"


@implementation MoefmApi

@synthesize plistDict;
@synthesize delegate;


- (void)recvData:(NSData *)data {
    [self performSelector:self.todo withObject:data];
}

- (id)init {
    self = [super init];
    if (self) {
        NSPropertyListFormat *plistFormat = nil;
        NSString *errorDesc = nil;
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MoeFM-Api" ofType:@"plist"];
        NSData *plistData = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        self.plistDict = (NSDictionary*)[NSPropertyListSerialization
                                         propertyListFromData:plistData
                                         mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                         format:plistFormat
                                         errorDescription:&errorDesc];
        
        self.apiKey = [self.plistDict objectForKey:@"apiKey"];
    }
    
    return self;
}


- (void)request {
    self.todo = @selector(parseInfoFromData:);
    
    NSString *theUrl = [self.plistDict objectForKey:@"requestUrl"];
    HttpConnection *theConnection = [[HttpConnection alloc] init];
    [theConnection sendAsynchronousRequestTo:theUrl delegate:self];
}


- (void)accessWithRequestToken: (NSString*)requestToken RequestTokenSecret: (NSString*)requestTokenSecret Verifier: (NSString*)verifier {
    self.todo = @selector(parseInfoFromData:);
    
    NSString *theUrl = [NSString stringWithFormat:@"%@?request_token=%@&request_token_secret=%@&verifier=%@", [self.plistDict objectForKey:@"accessUrl"], requestToken, requestTokenSecret, verifier];
    HttpConnection *theConnection = [[HttpConnection alloc] init];
    [theConnection sendAsynchronousRequestTo:theUrl delegate:self];
}


- (void)parseInfoFromData: (NSData*)data {
    NSDictionary *recvDict = [HttpConnection dictFrom:data];
    NSDictionary *resultDict;
    
    if ((recvDict == nil) || (! [recvDict objectForKey:@"status"])) {
        resultDict = nil;
    } else {
        resultDict = [recvDict objectForKey:@"info"];
    }
    
    [self.delegate recvApiData:resultDict];
}


- (void)getPlaylistOf:(int)count {
    self.todo = @selector(parsePlaylistFromData:);
    
    NSString *getUrl = [self.plistDict objectForKey:@"getUrl"];
    NSString *apiUrl = [self.plistDict objectForKey:@"playlistApiUrl"];
    NSString *theUrl = [NSString stringWithFormat:@"%@?url=%@&api_key=%@&api=json&perpage=%d", getUrl, apiUrl, self.apiKey, count];
    
    HttpConnection *theConnection = [[HttpConnection alloc] init];
    [theConnection sendAsynchronousRequestTo:theUrl delegate:self];
}

- (void)getPlaylist {
    [self getPlaylistOf:1];
}

- (void)parsePlaylistFromData: (NSData*)data {
    NSDictionary *recvDict = [HttpConnection dictFrom:data];
    NSDictionary *resultDict;
    
    if (recvDict == nil) {
        resultDict = nil;
    } else {
        resultDict = [[recvDict objectForKey:@"response"] objectForKey:@"playlist"];
    }
    
    [self.delegate recvApiData:resultDict];
}


- (void)sendFavRequestAction: (NSString*)action Type: (int)type SubId: (int)subId {
    self.todo = @selector(parseStandardApiInfoFromData:);
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *ogetUrl = [self.plistDict objectForKey:@"ogetUrl"];
    NSString *apiUrl = [self.plistDict objectForKey:[NSString stringWithFormat:@"%@FavApiUrl", action]];
    NSString *theUrl = [NSString stringWithFormat:@"%@?url=%@&access_token=%@&access_token_secret=%@&fav_obj_type=song&fav_type=%d&fav_obj_id=%d", ogetUrl, apiUrl, [ud stringForKey:@"accessToken"], [ud stringForKey:@"accessTokenSecret" ], type, subId];
    
    HttpConnection *theConnection = [[HttpConnection alloc] init];
    [theConnection sendAsynchronousRequestTo:theUrl delegate:self];
}

- (void)parseStandardApiInfoFromData: (NSData*)data {
    NSDictionary *recvDict = [HttpConnection dictFrom:data];
    NSDictionary *resultDict = [recvDict objectForKey:@"response"];
    
    if ((resultDict == nil) || ((int)[[resultDict objectForKey:@"information"] objectForKey:@"has_error"] == 1)) {
        resultDict = nil;
    }
    
    [self.delegate recvApiData:resultDict];
}

- (void)addFavSongBySubId:(int)subId {
    [self sendFavRequestAction:@"add" Type:1 SubId:subId];
}

- (void)deleteFavSongBySubId:(int)subId {
    [self sendFavRequestAction:@"delete" Type:1 SubId:subId];
}

- (void)addTrashSongBySubId:(int)subId {
    [self sendFavRequestAction:@"add" Type:2 SubId:subId];
}

@end






















