//
//  MoefmPlayer.m
//  MoeFM
//
//  Created by Kroderia on 12/28/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import "MoefmPlayer.h"

@implementation MoefmPlayer

@synthesize song;
@synthesize delegate = _delegate;

//==========================================
// Singleton
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
        [self performSelector:todo withObject:data];
    } else {
        [self delegatePerformOptionalSelector:@selector(errorRecvApiData:) Data:error];
        [self performSelector:todo withObject:nil];
    }
}

- (id)init {
    if (instance) {
        return instance;
    }
    
    self = [super init];
    if (self) {
        loading = NO;
        playing = NO;
        trashing = NO;
        faving = NO;
        
        self.moefmApi = [[MoefmApi alloc] init];
        self.moefmApi.delegate = self;
    }
    
    return self;
}

//==========================================
// Override
- (void)play {
    [super play];
    playing = YES;
    
    [self delegatePerformOptionalSelector:@selector(playerDidStartPlaying)];
}

- (void)pause {
    [super pause];
    playing = NO;
    
    [self delegatePerformOptionalSelector:@selector(playerDidPausePlaying)];
}

//==========================================
// Player action
- (void)playNextSong {
    if (loading || faving || trashing) {
        return;
    }
    
    loading = YES;
    [self pause];
    [self delegatePerformOptionalSelector:@selector(playerGoingToPlayNext)];
    [self addLog];
}

- (void)addLog {
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"useLogListen"] == NSOnState ||
        ! [MoefmApi isAuthorized] ||
        [((NSNumber*)[self.song objectForKey:@"sub_id"]) intValue] == 0 ||
        [self currentPlayTime] <= 30) {
        [self loadPlaylist];
    } else {
        todo = @selector(loadPlaylist);
        [self.moefmApi logListenToSubId:[((NSNumber*)[self.song objectForKey:@"sub_id"]) intValue]];
    }
}

- (void)loadSong: (NSArray*)playlist {
    if (playlist == nil) {
        loading = NO;
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
    
    loading = NO;
}

- (void)loadPlaylist {
    todo = @selector(loadSong:);
    [self.moefmApi getPlaylist];
}

//==========================================
// Get current status
- (BOOL)isLoading {
    return loading;
}

- (BOOL)isPlaying {
    return playing;
}

- (BOOL)isTrashing {
    return trashing;
}

- (BOOL)isFaving {
    return faving;
}

- (BOOL)isFav {
    id fav = [self.song objectForKey:@"fav_sub"];
    return ((fav != nil) && (fav != [NSNull null]));
}

//==========================================
// Operate the song
- (void)addTrash {
    trashing = YES;
    
    todo = @selector(trashResponse:);
    [self.moefmApi addTrashSongBySubId:[((NSNumber*)[self.song objectForKey:@"sub_id"]) intValue]];
}

- (void)trashResponse: (NSDictionary*)response {
    trashing = NO;
    
    if (response == nil) {
        [self delegatePerformOptionalSelector:@selector(errorTrashingSong)];
        return;
    }
    
    [self delegatePerformOptionalSelector:@selector(playerDidFinishTrashing)];
}

- (void)addFav {
    faving = YES;
    
    todo = @selector(favResponse:);
    [self.moefmApi addFavSongBySubId:[((NSNumber*)[self.song objectForKey:@"sub_id"]) intValue]];
}

- (void)deleteFav {
    faving = YES;
    
    todo = @selector(favResponse:);
    [self.moefmApi deleteFavSongBySubId:[((NSNumber*)[self.song objectForKey:@"sub_id"]) intValue]];
}

- (void)favResponse: (NSDictionary*)response {
    faving = NO;
    
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


//==========================================
// Get song time
- (double)currentPlayTime {
    [self test];
    return CMTimeGetSeconds(self.currentTime);
}

- (double)currentLoadTime {
    if (self.currentItem.loadedTimeRanges.count <= 0)
        return 0.0;
    
    CMTimeRange range = [[self.currentItem.loadedTimeRanges objectAtIndex:0] CMTimeRangeValue];
    double loadedtime = CMTimeGetSeconds(range.start) + CMTimeGetSeconds(range.duration);
    
    return loadedtime;
}

- (double)currentStreamTime {
    return [[self.song objectForKey:@"stream_length"] doubleValue];
}

//==========================================
// MultipleDelegate protocol
- (void)addDelegate:(id<MoefmPlayerDelegate>)delegate {
    if (self.delegate == nil) {
        self.delegate = [[NSMutableArray alloc] init];
    }
    
    [self.delegate addObject:delegate];
}

- (void)removeDelegate:(id<MoefmPlayerDelegate>)delegate {
    [self.delegate removeObject:delegate];
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

- (void)test {
}


@end




















