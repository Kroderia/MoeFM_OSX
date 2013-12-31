//
//  MoefmPlayerDelegate.h
//  MoeFM
//
//  Created by Kroderia on 12/28/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MoefmPlayerDelegate <NSObject>

@optional
- (void)errorLoadingSongInfo;
- (void)errorTrashingSong;
- (void)errorFavingSong;

- (void)songInfoDidLoaded;
- (void)playerUpdatePlayingTime;
- (void)playerGoingToPlayNext;
- (void)playerDidStartPlaying;
- (void)playerDidPausePlaying;
- (void)playerDidFinishTrashing;
- (void)playerDidFinishFaving;

- (void)playerDidFinishPlaying;
- (void)playerDidStalled;
- (void)playerDidFailedToPlayToEndTime;

@end
