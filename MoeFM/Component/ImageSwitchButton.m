//
//  ImageSwitchButton.m
//  MoeFM
//
//  Created by Kroderia on 1/24/14.
//  Copyright (c) 2014 im.kroderia. All rights reserved.
//

#import "ImageSwitchButton.h"

@implementation ImageSwitchButton

- (void)setImageWhenStateOn:(NSImage *)on {
    self.imageOn = on;
}

- (void)setImageWhenStateOff:(NSImage *)off {
    self.imageOff = off;
}

- (void)setImageWhenStateOn:(NSImage *)on Off:(NSImage *)off {
    [self setImageWhenStateOn:on];
    [self setImageWhenStateOff:off];
}

- (NSImage*)imageOfState: (NSInteger)state {
    if (state == NSOnState) {
        return self.imageOn;
    } else {
        return self.imageOff;
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [self setImage:[self imageOfState:(! self.state)]];
}

- (void)mouseExited:(NSEvent *)theEvent {
    [self setImage:[self imageOfState:self.state]];
}


@end
