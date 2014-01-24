//
//  MoefmStatusItem.m
//  MoeFM
//
//  Created by Kroderia on 12/30/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import "MoefmStatusItem.h"

@implementation MoefmStatusItem

@synthesize item;

- (void)errorFavingSong {
    [[EasyNotification instance] sendNotificationWithTitle:@"出错了>_<" Message:@"进行操作时出错了, 重试一下吧..."];
}

- (void)errorTrashingSong {
    [self.moefmPlayer playNextSong];
}

- (void)errorRecvApiData:(NSDictionary *)error {
    [[EasyNotification instance] sendNotificationWithTitle:[error objectForKey:@"title"] Message:[error objectForKey:@"message"]];
    if ([[error objectForKey:@"code"] integerValue] == 401) {
        [MoefmApi clearAuthorized];
    }
    [self.moefmPlayer playNextSong];
    [self.item setTitle:@"(￣皿￣)"];
}

- (void)playerDidPausePlaying {
    [self.item setTitle:@"( ´_っ`)"];
    [[self.item.menu itemWithTitle:@"暂停"] setTitle:@"播放"];
}

- (void)playerDidStartPlaying {
    self.errorCounter = 0;
    [[self.item.menu itemWithTitle:@"播放"] setTitle:@"暂停"];
    [self.item setTitle:@"(ノﾟ∀ﾟ)ノ"];
}

- (void)playerDidFinishPlaying {
    [self.moefmPlayer playNextSong];
}

- (void)playerDidStalled {
    NSLog(@"STALL");
}

- (void)songInfoDidLoaded {
}

- (void)playerDidFailedToPlayToEndTime {
    [self errorRecvApiData:[NSDictionary dictionaryWithObjectsAndKeys:@"载入歌曲失败", @"title", [NSNumber numberWithInt: 1], @"retry", @"正在为你加载下一首", @"message", nil]];
}

- (void)playerDidFinishTrashing {
    [self.moefmPlayer playNextSong];
}

- (void)playerDidFinishFaving {
    if ([[MoefmPlayer sharedInstance] isFav]) {
        [[[self.item menu] itemWithTitle:@"收藏"] setTitle:@"取消收藏"];
    } else {
        [[[self.item menu] itemWithTitle:@"取消收藏"] setTitle:@"收藏"];
    }
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.moefmPlayer = [MoefmPlayer sharedInstance];
        [self.moefmPlayer addDelegate:self];
        self.item = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
        [self.item setHighlightMode:YES];
        [self.item setTitle:@"(ノﾟ∀ﾟ)ノ"];
    }
    
    return self;
}

- (void)setMenu:(NSMenu *)menu {
    [self.item setMenu:menu];
}



@end
