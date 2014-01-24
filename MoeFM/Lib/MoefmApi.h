//
//  MoefmApi.h
//  MoeFM
//
//  Created by Kroderia on 12/17/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpConnectionRecvDelegate.h"
#import "MoefmApiDelegate.h"

@interface MoefmApi : NSObject<HttpConnectionRecvDelegate>
{
    NSString *apiKey;
    NSDictionary *plistDict;
    SEL todo;
}

@property (weak) id<MoefmApiDelegate> delegate;

+ (BOOL)isAuthorized;
+ (void)clearAuthorized;

- (void)request;
- (void)accessWithRequestToken: (NSString*)requestToken RequestTokenSecret: (NSString*)requestTokenSecret Verifier: (NSString*)verifier;

- (void)getPlaylist;
- (void)getPlaylistOf: (int)count;
- (void)deleteFavSongBySubId: (int)subId;
- (void)addFavSongBySubId: (int)subId;
- (void)addTrashSongBySubId: (int)subId;
- (void)logListenToSubId: (int)subId;

- (void)recvData:(NSData *)data;

@end
