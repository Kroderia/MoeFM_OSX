//
//  MoefmPlayerDelegate.h
//  MoeFM
//
//  Created by Kroderia on 12/28/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MoefmPlayerDelegate <NSObject>

@required
- (void)errorLoadingSongInfo;
- (void)errorLoadingSongData;
- (void)errorTrashingSong;
- (void)errorFavingSong;

@optional
- (void)songInfoDidLoaded;
- (void)playerUpdatePlayingTime;
- (void)playerGoingToPlayNext;
- (void)playerDidFinishPlaying;
- (void)playerDidStartPlaying;
- (void)playerDidPausePlaying;
- (void)playerDidFinishTrashing;
- (void)playerDidFinishFaving;

@end
