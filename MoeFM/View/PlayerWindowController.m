//
//  PlayerWindowController.m
//  MoeFM
//
//  Created by Kroderia on 1/24/14.
//  Copyright (c) 2014 im.kroderia. All rights reserved.
//

#import "PlayerWindowController.h"

@interface PlayerWindowController ()

@end

@implementation PlayerWindowController

- (void)songInfoDidLoaded {
    [self showSongStatus];
}

- (void)playerDidStartPlaying {
    [self resetPlayBtn];
}

- (void)playerDidPausePlaying {
    [self resetPlayBtn];
}

- (void)playerGoingToPlayNext {
    [self showLoadingStatus];
}

- (void)playerDidFinishFaving {
    [self resetFavBtn];
}

- (void)playerUpdatePlayingTime {
    if (moefmPlayer.isLoading) {
        return;
    }
    
    double duration = [moefmPlayer currentStreamTime];
    double played = [moefmPlayer currentPlayTime];
    double loaded = [moefmPlayer currentLoadTime];
    int left = (int)(duration - played);
    if (left < 0) {
        return;
    }
    
    [self.songProgressBar setPlayedWidthOf:played / duration];
    [self.songProgressBar setLoadedWidthOf:loaded / duration];
    self.songProgressTimer.stringValue = [NSString stringWithFormat:@"-%02d:%02d", left/60, left%60];
}


- (void)windowDidLoad {
    [super windowDidLoad];
    
    moefmPlayer = [MoefmPlayer sharedInstance];
    [moefmPlayer addDelegate:self];
    
    [self.songTitleText setAttributes:@{NSFontAttributeName: [NSFont systemFontOfSize:24]}];
    [self.songTitleText setDistant:48.0f];
    [self.songAlbumText setAttributes:@{NSFontAttributeName: [NSFont systemFontOfSize:16]}];
    [self.songAlbumText setDistant:32.0f];
    
    [self.favBtn setImageWhenStateOn:[NSImage imageNamed:@"btn_fav.png"] Off:[NSImage imageNamed:@"btn_tofav.png"]];
    [self.playBtn setImageWhenStateOn:[NSImage imageNamed:@"btn_play.png"] Off:[NSImage imageNamed:@"btn_pause.png"]];
    [self.trashBtn setImageWhenStateOn:[NSImage imageNamed:@"btn_trash.png"] Off:[NSImage imageNamed:@"btn_totrash.png"]];
    [self.nextBtn setImageWhenStateOn:[NSImage imageNamed:@"btn_next.png"] Off:[NSImage imageNamed:@"btn_next.png"]];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"logo_512" ofType:@"png"];
    songCoverDefault = [[NSImage alloc] initWithContentsOfFile:path];
    
    [moefmPlayer playNextSong];
}

- (void)showLoadingStatus {
    self.songCoverBtn.image = songCoverDefault;
    [self.songTitleText setString:@"少女载入中..." Speed: 0.1f];
    [self.songAlbumText setString:@"......" Speed:0.05f];
    self.songProgressTimer.stringValue = @"-00:00";
    [self.songProgressBar resetProgress];
    [self.favBtn setState:NSOffState];
}

- (void)showSongStatus {
    NSDictionary *song = moefmPlayer.song;
    
    int duration = ceil([moefmPlayer currentStreamTime]);
    self.songProgressTimer.stringValue = [NSString stringWithFormat:@"-%02d:%02d", duration/60, duration%60];
    [self.songProgressBar resetProgress];
    
    [self changeSongCoverByImageUrl:[[song objectForKey:@"cover"] objectForKey:@"small"]];
    [self.songTitleText setString:[song objectForKey:@"sub_title"] Speed: 0.1f];
    [self.songAlbumText setString:[song objectForKey:@"wiki_title"] Speed: 0.05f];
    [self resetFavBtn];
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"alwaysTop"] == NSOffState) {
        [[EasyNotification instance] sendNotificationWithTitle:[song objectForKey:@"sub_title"] Message:[song objectForKey:@"wiki_title"]];
    }
}

- (void)resetFavBtn {
    [self.favBtn setState:moefmPlayer.isFav];
}

- (void)resetPlayBtn {
    [self.playBtn setState:moefmPlayer.isPlaying];
}


- (void)changeSongCoverByImageUrl: (NSString*)imageUrl {
    self.songCoverImage = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    self.songCoverBtn.image = self.songCoverImage;
}

- (void)itemDidFinishPlaying: (NSNotification*)notification {
    [moefmPlayer playNextSong];
}

- (IBAction)clickPlayBtn:(id)sender {
    if (moefmPlayer.isLoading) {
        return;
    }
    
    if (moefmPlayer.isPlaying) {
        [moefmPlayer pause];
    } else {
        [moefmPlayer play];
    }
}

- (IBAction)clickNextBtn:(id)sender {
    if (moefmPlayer.isLoading) {
        return;
    }
    
    [moefmPlayer playNextSong];
}

- (IBAction)clickTrashBtn:(id)sender {
    if (moefmPlayer.isTrashing || moefmPlayer.isLoading) {
        return;
    }
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"] == nil) {
        [self showUnauthorizeToActAlert];
        return;
    }
    
    [moefmPlayer addTrash];
}

- (IBAction)clickFavBtn:(id)sender {
    if (moefmPlayer.isFaving) {
        return;
    }
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"] == nil) {
        [self showUnauthorizeToActAlert];
        return;
    }
    
    if (moefmPlayer.isFav) {
        [moefmPlayer deleteFav];
    } else {
        [moefmPlayer addFav];
    }
}

- (void)showUnauthorizeToActAlert {
    NSAlert *alert = [NSAlert alertWithMessageText:@"当前尚未授权, 无法进行该操作. 先到偏好设置进行授权吧." defaultButton:@"你没机会的, 只能点我" alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
    [alert runModal];
}


@end
