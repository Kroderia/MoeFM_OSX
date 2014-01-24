//
//  ImageSwitchButton.h
//  MoeFM
//
//  Created by Kroderia on 1/24/14.
//  Copyright (c) 2014 im.kroderia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ImageSwitchButton : NSButton
{
    NSTrackingRectTag btnTrackingRectTag;
}

@property (nonatomic, weak) NSImage *imageOn;
@property (nonatomic, weak) NSImage *imageOff;

- (void)setImageWhenStateOn: (NSImage*)on Off: (NSImage*)off;
- (void)setImageWhenStateOn: (NSImage*)on;
- (void)setImageWhenStateOff: (NSImage*)off;

- (void)mouseEntered:(NSEvent *)theEvent;
- (void)mouseExited:(NSEvent *)theEvent;

@end
