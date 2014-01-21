//
//  MoefmPlayer.m
//  MoeFM
//
//  Created by Kroderia on 12/28/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import "MoefmPlayer.h"

@implementation MoefmPlayer

@synthesize isLoading;
@synthesize isPlaying;
@synthesize isTrashing;
@synthesize isFaving;
@synthesize song;

static MoefmPlayer *instance = nil;

+ (MoefmPlayer*)sharedInstance {
    if (instance == nil) {
        instance = [[super allocWithZone:NULL] init];
    }
    return instance;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (void)recvApiData:(id)data Error:(NSDictionary *)error {
    if ([[error objectForKey:@"code"] integerValue] == 100) {
        [self performSelector:self.todo withObject:data];
    } else {
        [self delegatePerformOptionalSelector:@selector(errorRecvApiData:) Data:error];
        [self performSelector:self.todo withObject:nil];
    }
}

- (id)init {
    if (instance) {
        return instance;
    }
    
    self = [super init];
    if (self) {
        self.isLoading = NO;
        self.isPlaying = NO;
        self.isTrashing = NO;
        self.isFaving = NO;
        
        self.moefmApi = [[MoefmApi alloc] init];
        self.moefmApi.delegate = self;
    }
    
    return self;
}

- (void)play {
    [super play];
    self.isPlaying = YES;
    
    [self delegatePerformOptionalSelector:@selector(playerDidStartPlaying)];
}

- (void)pause {
    [super pause];
    self.isPlaying = NO;
    
    [self delegatePerformOptionalSelector:@selector(playerDidPausePlaying)];
}

- (void)playNextSong {
    if (self.isLoading || self.isFaving || self.isTrashing) {
        return;
    }
    
    self.isLoading = YES;
    [self delegatePerformOptionalSelector:@selector(playerGoingToPlayNext)];
    [self pause];
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"useLogListen"] == NSOnState) {
        [self addLog];
    } else {
        [self loadPlaylist];
    }
}

- (void)loadSong: (NSArray*)playlist {
    if (playlist == nil) {
        self.isLoading = NO;
        [self delegatePerformOptionalSelector:@selector(errorLoadingSongInfo)];
        return;
    }
    
    self.song = [NSMutableDictionary dictionaryWithDictionary:[playlist objectAtIndex:0]];
    [self delegatePerformOptionalSelector:@selector(songInfoDidLoaded)];
    
    AVPlayerItem *songItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:[self.song objectForKey:@"url"]]];
    
    [self delegateAddObserverWithSelector:@selector(playerDidFinishPlaying) Name:AVPlayerItemDidPlayToEndTimeNotification];
    [self delegateAddObserverWithSelector:@selector(playerDidFailedToPlayToEndTime) Name:AVPlayerItemFailedToPlayToEndTimeNotification];
    [self delegateAddObserverWithSelector:@selector(playerDidStalled) Name:AVPlayerItemPlaybackStalledNotification];
    
    [self replaceCurrentItemWithPlayerItem:songItem];
    [self play];
    
    [self delegateAddTimeObserverWithSelector:@selector(playerUpdatePlayingTime)
                                        Timer:CMTimeMakeWithSeconds(1.0f, NSEC_PER_SEC)];
    
    self.isLoading = NO;
}

- (BOOL)isFav {
    id fav = [self.song objectForKey:@"fav_sub"];
    return ((fav != nil) && (fav != [NSNull null]));
}

- (void)addTrash {
    self.isTrashing = YES;
    
    self.todo = @selector(trashResponse:);
    [self.moefmApi addTrashSongBySubId:[((NSNumber*)[self.song objectForKey:@"sub_id"]) intValue]];
}

- (void)trashResponse: (NSDictionary*)response {
    self.isTrashing = NO;
    
    if (response == nil) {
        [self delegatePerformOptionalSelector:@selector(errorTrashingSong)];
        return;
    }
    
    [self delegatePerformOptionalSelector:@selector(playerDidFinishTrashing)];
}

- (void)addFav {
    self.isFaving = YES;
    
    self.todo = @selector(favResponse:);
    [self.moefmApi addFavSongBySubId:[((NSNumber*)[self.song objectForKey:@"sub_id"]) intValue]];
}

- (void)deleteFav {
    self.isFaving = YES;
    
    self.todo = @selector(favResponse:);
    [self.moefmApi deleteFavSongBySubId:[((NSNumber*)[self.song objectForKey:@"sub_id"]) intValue]];
}

- (void)addLog {
    if ([((NSNumber*)[self.song objectForKey:@"sub_id"]) intValue] == 0 || ! [MoefmApi isAuthorized]) {
        [self loadPlaylist];
    } else {
        self.todo = @selector(loadPlaylist);
        [self.moefmApi logListenToSubId:[((NSNumber*)[self.song objectForKey:@"sub_id"]) intValue]];
    }
}

- (void)loadPlaylist {
    self.todo = @selector(loadSong:);
    [self.moefmApi getPlaylist];
}

- (double)currentPlayTime {
    return CMTimeGetSeconds(self.currentTime);
}

- (double)currentLoadTime {
    CMTimeRange range = [[self.currentItem.loadedTimeRanges objectAtIndex:0] CMTimeRangeValue];
    double loadedtime = CMTimeGetSeconds(range.start) + CMTimeGetSeconds(range.duration);
    
    return loadedtime;
}

- (double)currentStreamTime {
    return [[self.song objectForKey:@"stream_length"] doubleValue];
}

- (void)favResponse: (NSDictionary*)response {
    self.isFaving = NO;
    
    if (response == nil) {
        [self delegatePerformOptionalSelector:@selector(errorFavingSong)];
        return;
    }
    
    if ([response objectForKey:@"fav"] == nil) {
        [self.song removeObjectForKey:@"fav_sub"];
    } else {
        [self.song setObject:[response objectForKey:@"fav"] forKey:@"fav_sub"];
    }
    
    [self delegatePerformOptionalSelector:@selector(playerDidFinishFaving)];
}


- (void)addDelegate:(id<MoefmPlayerDelegate>)delegate {
    if (self.delegate == nil) {
        self.delegate = [[NSMutableArray alloc] init];
    }
    
    [self.delegate addObject:delegate];
}

- (void)delegatePerformOptionalSelector: (SEL)selector {
    [self delegatePerformOptionalSelector:selector Data:nil];
}

- (void)delegatePerformOptionalSelector: (SEL)selector Data: (id)data {
    for (id<MoefmPlayerDelegate> entry in self.delegate) {
        if (entry == nil) {
            [self.delegate removeObject:entry];
            continue;
        }
        
        if ([entry respondsToSelector:selector]) {
            [entry performSelector:selector withObject:data];
        }
    }
}

- (void)delegateAddObserverWithSelector: (SEL)selector Name: (id)name {
    for (id<MoefmPlayerDelegate> entry in self.delegate) {
        if ([entry respondsToSelector:selector]) {
            [[NSNotificationCenter defaultCenter] addObserver:entry
                                                     selector:selector
                                                         name:name
                                                       object:nil];
        }
    }
}

- (void)delegateAddTimeObserverWithSelector: (SEL)selector Timer: (CMTime)timer {
    for (id<MoefmPlayerDelegate> entry in self.delegate) {
        if ([entry respondsToSelector:selector]) {
            [self addPeriodicTimeObserverForInterval:timer
                                               queue:NULL
                                          usingBlock:^(CMTime time) { [entry performSelector:selector]; }];
        }
    }
}

@end




















