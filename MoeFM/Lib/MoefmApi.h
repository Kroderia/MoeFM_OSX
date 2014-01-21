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

@property (strong) NSString *apiKey;
@property (strong) NSDictionary *plistDict;

@property (weak) id<MoefmApiDelegate> delegate;
@property SEL todo;

+ (BOOL)isAuthorized;
+ (void)clearAuthorized;

- (void)request;
- (void)accessWithRequestToken: (NSString*)requestToken RequestTokenSecret: (NSString*)requestTokenSecret Verifier: (NSString*)verifier;

- (void)getPlaylistOf: (int)count;
- (void)getPlaylist;
- (void)addTrashSongBySubId: (int)subId;
- (void)addFavSongBySubId: (int)subId;
- (void)deleteFavSongBySubId: (int)subId;
- (void)logListenToSubId: (int)subId;

- (void)recvData:(NSData *)data;

@end
