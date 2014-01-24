//
//  ScrollTextView.h
//  MoeFM
//
//  Created by Kroderia on 12/28/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ScrollTextView : NSView
{
    float drawDistant;
    NSString *drawString;
    NSPoint drawPoint;
    NSDictionary *drawAttributes;
    NSTimer *drawTimer;
}

- (void)setDistant: (float)distant;
- (void)setString: (NSString*)string Speed: (NSTimeInterval)speed;
- (void)setAttributes: (NSDictionary*)attributes;
- (void)scrollWithSpeed: (NSTimeInterval)speed;

@end
