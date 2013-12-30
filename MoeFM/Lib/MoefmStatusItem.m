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
    [self errorFavingSong];
}

- (void)errorLoadingSongData {
    [self errorLoadingSongInfo];
}

- (void)errorLoadingSongInfo {
    self.errorCounter += 1;
    if (self.errorCounter > 5) {
        [[EasyNotification instance] sendNotificationWithTitle:@"出错了>_<" Message:@"出错次数过多, 可能你的网络有问题. 检查后再点击播放吧."];
        self.errorCounter = 0;
        return;
    }
    
    [[EasyNotification instance] sendNotificationWithTitle:@"出错了>_<" Message:@"载入歌曲时出错, 正在为你加载下一首"];
    [[MoefmPlayer sharedInstance] playNextSong];
    [self.item setTitle:@"(￣皿￣)"];
}

- (void)playerDidPausePlaying {
    [self.item setTitle:@"( ´_っ`)"];
}

- (void)playerDidStartPlaying {
    self.errorCounter = 0;
    [self.item setTitle:@"(ノﾟ∀ﾟ)ノ"];
}

- (void)playerDidFinishTrashing {
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
        [[MoefmPlayer sharedInstance] addDelegate:self];
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
