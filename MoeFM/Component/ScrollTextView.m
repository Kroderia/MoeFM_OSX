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
    drawDistant = distant;
}

- (void)setString:(NSString *)string Speed:(NSTimeInterval)speed {
    [drawTimer invalidate];
    drawTimer = nil;
    
    drawString = [string copy];
    drawPoint = NSZeroPoint;
    
    [self scrollWithSpeed:speed];
    [self setNeedsDisplay:YES];
}

- (void)setAttributes:(NSDictionary *)attributes {
    drawAttributes = [attributes copy];
}

- (void)scrollWithSpeed: (NSTimeInterval)speed {
    if ([drawString sizeWithAttributes:drawAttributes].width < self.frame.size.width) {
        return;
    }
    
    [drawTimer invalidate];
    drawTimer = [NSTimer scheduledTimerWithTimeInterval:speed target:self selector:@selector(moveText:) userInfo:nil repeats:YES];
}

- (void)moveText:(NSTimer*)timer {
    drawPoint.x -= 1.0f;
    [self setNeedsDisplay:YES];
}


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    if (drawTimer == nil) {
        [drawString drawAtPoint:drawPoint
                 withAttributes:drawAttributes];
        return;
    }
    
    float width = [drawString sizeWithAttributes: drawAttributes].width;
    if (drawPoint.x + width*2 + drawDistant <= dirtyRect.size.width) {
        NSPoint newPoint = drawPoint;
        newPoint.x = dirtyRect.size.width + drawDistant;
        drawPoint = newPoint;
    }
    
    NSPoint anotherPoint = drawPoint;
    float pointDistant = width + drawDistant;
    if (drawPoint.x <= 0) {
        anotherPoint.x += pointDistant;
    } else {
        anotherPoint.x -= pointDistant;
    }
    
    [drawString drawAtPoint: drawPoint
             withAttributes: drawAttributes];
    [drawString drawAtPoint: anotherPoint
             withAttributes: drawAttributes];
}

@end
