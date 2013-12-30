//
//  PlayerViewController.m
//  MoeFM
//
//  Created by Kroderia on 12/17/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import "PlayerViewController.h"

@interface PlayerViewController ()

@end

@implementation PlayerViewController

- (void)songInfoDidLoaded {
    [self showSongStatus];
}

- (void)errorLoadingSongInfo {
    self.errorCounter += 1;
    if (self.errorCounter > 5) {
        [[EasyNotification instance] sendNotificationWithTitle:@"出错了>_<" Message:@"出错次数过多, 可能你的网络有问题. 检查后再点击播放吧."];
        self.errorCounter = 0;
        return;
    }
    
    [[EasyNotification instance] sendNotificationWithTitle:@"出错了>_<" Message:@"载入歌曲时出错, 正在为你加载下一首"];
    [self playSong];
}

- (void)errorLoadingSongData {
    [self errorLoadingSongInfo];
}

- (void)errorTrashingSong {
    [[EasyNotification instance] sendNotificationWithTitle:@"出错了>_<" Message:@"抛弃歌曲时出错了, 重试一下吧..."];
}

- (void)errorFavingSong {
    [[EasyNotification instance] sendNotificationWithTitle:@"出错了>_<" Message:@"执行操作时出错了, 重试一下吧..."];
}

- (void)playerDidFinishPlaying {
    [self.moefmPlayer playNextSong];
}

- (void)playerDidStartPlaying {
    [self.playBtn setImage:[NSImage imageNamed:@"btn_pause.png"]];
    self.errorCounter = 0;
}

- (void)playerDidPausePlaying {
    [self.playBtn setImage:[NSImage imageNamed:@"btn_play.png"]];
}

- (void)playerGoingToPlayNext {
    [self showLoadingStatus];
}

- (void)playerDidFinishTrashing {
    [self.moefmPlayer playNextSong];
}

- (void)playerDidFinishFaving {
    [self resetFavBtn];
}

- (void)playerUpdatePlayingTime {
    if (self.moefmPlayer.currentItem.status == AVPlayerItemStatusFailed) {
        [[EasyNotification instance] sendNotificationWithTitle:@"出错了>_<" Message:@"载入歌曲时出错, 正在为你加载下一首"];
        [self.moefmPlayer playNextSong];
        return;
    }

    double time = CMTimeGetSeconds([self.moefmPlayer currentTime]);
    double duration = [self playerItemDuration];
    int left = (int)(duration - time);
    
    [self.songProgressBar setPlayedWidthOf:time / duration];
    self.songProgressTimer.stringValue = [NSString stringWithFormat:@"-%02d:%02d", left/60, left%60];

    CMTimeRange range = [[[self.moefmPlayer currentItem].loadedTimeRanges objectAtIndex:0] CMTimeRangeValue];
    time = CMTimeGetSeconds(range.start) + CMTimeGetSeconds(range.duration);

    [self.songProgressBar setLoadedWidthOf:time / duration];
}


- (void)loadView {
    [super loadView];
    
    self.moefmPlayer = [MoefmPlayer sharedInstance];
    [self.moefmPlayer addDelegate:self];
    self.errorCounter = 0;
    
    [self.songTitleText setAttributes:@{NSFontAttributeName: [NSFont systemFontOfSize:24]}];
    [self.songTitleText setDistant:48.0f];
    [self.songAlbumText setAttributes:@{NSFontAttributeName: [NSFont systemFontOfSize:16]}];
    [self.songAlbumText setDistant:32.0f];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"logo_512" ofType:@"png"];
    self.songCoverDefault = [[NSImage alloc] initWithContentsOfFile:path];

    [self playSong];
}


- (void)playSong {
    [self showLoadingStatus];
    [self.moefmPlayer playNextSong];
}


- (void)showLoadingStatus {
    self.songCoverImageView.image = self.songCoverDefault;
    [self.songTitleText setString:@"傻猫载入中..." Speed: 0.1f];
    [self.songAlbumText setString:@"......" Speed:0.05f];
    self.songProgressTimer.stringValue = @"-00:00";
    [self.favBtn setImage:[NSImage imageNamed:@"btn_tofav.png"]];
}


- (void)showSongStatus {
    NSDictionary *song = self.moefmPlayer.song;
    
    int duration = ceil([self playerItemDuration]);
    self.songProgressTimer.stringValue = [NSString stringWithFormat:@"-%02d:%02d", duration/60, duration%60];
    [self.songProgressBar resetProgress];
    
    [self changeSongCoverByImageUrl:[[song objectForKey:@"cover"] objectForKey:@"small"]];
    [self.songTitleText setString:[song objectForKey:@"sub_title"] Speed: 0.1f];
    [self.songAlbumText setString:[song objectForKey:@"wiki_title"] Speed: 0.05f];
    [self resetFavBtn];
    
    [[EasyNotification instance] sendNotificationWithTitle:[song objectForKey:@"sub_title"] Message:[song objectForKey:@"wiki_title"]];
}

- (void)resetFavBtn {
    if ([self.moefmPlayer isFav]) {
        [self.favBtn setImage:[NSImage imageNamed:@"btn_fav"]];
    } else {
        [self.favBtn setImage:[NSImage imageNamed:@"btn_tofav"]];
    }
}


- (void)changeSongCoverByImageUrl: (NSString*)imageUrl {
    self.songCoverImage = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    self.songCoverImageView.image = self.songCoverImage;
}

- (void)itemDidFinishPlaying: (NSNotification*)notification {
    [self playSong];
}

- (double)playerItemDuration {
// TODO: This time duration is not exactly correct
    return [[self.moefmPlayer.song objectForKey:@"stream_length"] doubleValue];
}

- (IBAction)clickPlayBtn:(id)sender {
    if (self.moefmPlayer.isLoading) {
        return;
    }
    
    if (self.moefmPlayer.isPlaying) {
        [self.moefmPlayer pause];
    } else {
        [self.moefmPlayer play];
    }
}

- (IBAction)clickNextBtn:(id)sender {
    if (self.moefmPlayer.isLoading) {
        return;
    }
    
    [self.moefmPlayer playNextSong];
}

- (IBAction)clickTrashBtn:(id)sender {
    if ([self.moefmPlayer isTrashing] || [self.moefmPlayer isLoading]) {
        return;
    }
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"] == nil) {
        [self showUnauthorizeToActAlert];
        return;
    }
    
    [self.moefmPlayer addTrash];
}

- (IBAction)clickFavBtn:(id)sender {
    if ([self.moefmPlayer isFaving]) {
        return;
    }
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"] == nil) {
        [self showUnauthorizeToActAlert];
        return;
    }
    
    if ([self.moefmPlayer isFav]) {
        [self.moefmPlayer deleteFav];
    } else {
        [self.moefmPlayer addFav];
    }
}

- (void)showUnauthorizeToActAlert {
    NSAlert *alert = [NSAlert alertWithMessageText:@"当前尚未授权, 无法进行该操作. 先到偏好设置进行授权吧." defaultButton:@"你没机会的, 只能点我" alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
    [alert runModal];
}



@end
























