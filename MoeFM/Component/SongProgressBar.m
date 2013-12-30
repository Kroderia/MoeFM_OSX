//
//  SongProgressBar.m
//  MoeFM
//
//  Created by Kroderia on 12/22/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import "SongProgressBar.h"

@implementation SongProgressBar


- (void)resetProgress {
    [self.loadedProgressView removeFromSuperview];
    [self.playedProgressView removeFromSuperview];
    
    NSRect frame = self.frame;
    frame.size.width = 0.0f;
    
    self.loadedProgressView = [[NSBox alloc] initWithFrame:frame];
    self.loadedProgressView.titlePosition = NSNoTitle;
    self.loadedProgressView.boxType = NSBoxCustom;
    self.loadedProgressView.borderType = NSNoBorder;
    self.loadedProgressView.fillColor = [NSColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f];
    
    self.playedProgressView = [[NSBox alloc] initWithFrame:frame];
    self.playedProgressView.titlePosition = NSNoTitle;
    self.playedProgressView.boxType = NSBoxCustom;
    self.playedProgressView.borderType = NSNoBorder;
    self.playedProgressView.fillColor = [NSColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:1.0f];
    
    [self addSubview:self.loadedProgressView];
    [self addSubview:self.playedProgressView];
}


- (void)setLoadedWidthOf:(float)rate {
    NSRect frame = ((NSView*)self.contentView).frame;
    frame.size.width = frame.size.width * rate;
    
    self.loadedProgressView.frame = frame;
}


- (void)setPlayedWidthOf:(float)rate {
    NSRect frame = ((NSView*)self.contentView).frame;
    frame.size.width = frame.size.width * rate;
    
    self.playedProgressView.frame = frame;
}



@end
