//
//  ScrollTextView.m
//  MoeFM
//
//  Created by Kroderia on 12/28/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import "ScrollTextView.h"

@implementation ScrollTextView


- (void)setDistant:(float)distant {
    self.drawDistant = distant;
}

- (void)setString:(NSString *)string Speed:(NSTimeInterval)speed {
    [self.drawTimer invalidate];
    self.drawTimer = nil;
    
    self.drawString = [string copy];
    self.drawPoint = NSZeroPoint;
    
    [self scrollWithSpeed:speed];
    [self setNeedsDisplay:YES];
}

- (void)setAttributes:(NSDictionary *)attributes {
    self.drawAttributes = [attributes copy];
}

- (void)scrollWithSpeed: (NSTimeInterval)speed {
    if ([self.drawString sizeWithAttributes:self.drawAttributes].width < self.frame.size.width) {
        return;
    }
    
    [self.drawTimer invalidate];
    self.drawTimer = [NSTimer scheduledTimerWithTimeInterval:speed target:self selector:@selector(moveText:) userInfo:nil repeats:YES];
}

- (void)moveText:(NSTimer*)timer {
    NSPoint newPoint = self.drawPoint;
    newPoint.x -= 1.0f;
    
    self.drawPoint = newPoint;
    [self setNeedsDisplay:YES];
}


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    if (self.drawTimer == nil) {
        [self.drawString drawAtPoint:self.drawPoint withAttributes:self.drawAttributes];
        return;
    }
    
    float width = [self.drawString sizeWithAttributes:self.drawAttributes].width;
    if (self.drawPoint.x + width*2 + self.drawDistant <= dirtyRect.size.width) {
        NSPoint newPoint = self.drawPoint;
        newPoint.x = dirtyRect.size.width + self.drawDistant;
        self.drawPoint = newPoint;
    }
    
    NSPoint anotherPoint = self.drawPoint;
    float pointDistant = width + self.drawDistant;
    if (self.drawPoint.x <= 0) {
        anotherPoint.x += pointDistant;
    } else {
        anotherPoint.x -= pointDistant;
    }
    
    [self.drawString drawAtPoint:self.drawPoint withAttributes:self.drawAttributes];
    [self.drawString drawAtPoint:anotherPoint withAttributes:self.drawAttributes];
}

@end
