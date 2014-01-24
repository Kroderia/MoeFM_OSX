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
#import "MultipleDelegate.h"

@interface MoefmPlayer : AVPlayer<MoefmApiDelegate, MultipleDelegate>
{
    BOOL loading;
    BOOL playing;
    BOOL trashing;
    BOOL faving;
    SEL todo;
}

@property (strong) NSMutableDictionary *song;
@property (strong) MoefmApi *moefmApi;

+ (MoefmPlayer*)sharedInstance;

- (void)playNextSong;

- (void)addTrash;
- (void)addFav;
- (void)deleteFav;

- (BOOL)isLoading;
- (BOOL)isPlaying;
- (BOOL)isTrashing;
- (BOOL)isFaving;
- (BOOL)isFav;

- (double)currentPlayTime;
- (double)currentLoadTime;
- (double)currentStreamTime;

@end
