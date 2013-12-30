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
    [self errorLoadingSongInfo];
}

- (void)errorLoadingSongData {
    [self errorLoadingSongInfo];
}

- (void)errorLoadingSongInfo {
    [self.item setTitle:@"(￣皿￣)"];
}

- (void)errorTrashingSong {
    [self errorLoadingSongInfo];
}

- (void)playerDidPausePlaying {
    [self.item setTitle:@"( ´_っ`)"];
}

- (void)playerDidStartPlaying {
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
