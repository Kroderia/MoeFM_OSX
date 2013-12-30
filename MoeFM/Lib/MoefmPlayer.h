//
//  MoefmPlayer.h
//  MoeFM
//
//  Created by Kroderia on 12/28/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "MoefmApi.h"
#import "MoefmApiDelegate.h"
#import "MoefmPlayerDelegate.h"

@interface MoefmPlayer : AVPlayer<MoefmApiDelegate>

@property BOOL isLoading;
@property BOOL isPlaying;
@property BOOL isTrashing;
@property BOOL isFaving;

@property (strong) NSMutableArray *delegate;
@property (strong) NSMutableDictionary *song;
@property (strong) MoefmApi *moefmApi;
@property SEL todo;

+ (MoefmPlayer*)sharedInstance;

- (void)addDelegate: (id<MoefmPlayerDelegate>)delegate;
- (void)playNextSong;
- (BOOL)isFav;
- (void)addTrash;
- (void)addFav;
- (void)deleteFav;

@end
