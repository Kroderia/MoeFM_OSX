//
//  SongProgressBar.m
//  MoeFM
//
//  Created by Kroderia on 12/22/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import "SongProgressBar.h"

@implementation SongProgressBar


- (void)awakeFromNib {
    NSRect frame = self.frame;
    frame.size.width = 0.0f;
    
    loadedProgressView = [[NSBox alloc] initWithFrame:frame];
    loadedProgressView.titlePosition = NSNoTitle;
    loadedProgressView.boxType = NSBoxCustom;
    loadedProgressView.borderType = NSNoBorder;
    loadedProgressView.fillColor = [NSColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f];
    
    playedProgressView = [[NSBox alloc] initWithFrame:frame];
    playedProgressView.titlePosition = NSNoTitle;
    playedProgressView.boxType = NSBoxCustom;
    playedProgressView.borderType = NSNoBorder;
    playedProgressView.fillColor = [NSColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:1.0f];
    
    [self addSubview:loadedProgressView];
    [self addSubview:playedProgressView];
}

- (void)resetProgress {
    [self setPlayedWidthOf:0.0f];
    [self setLoadedWidthOf:0.0f];
}


- (void)setLoadedWidthOf:(float)rate {
    NSRect frame = ((NSView*)self.contentView).frame;
    frame.size.width = frame.size.width * rate;
    
    loadedProgressView.frame = frame;
}


- (void)setPlayedWidthOf:(float)rate {
    NSRect frame = ((NSView*)self.contentView).frame;
    frame.size.width = frame.size.width * rate;
    
    playedProgressView.frame = frame;
}



@end
