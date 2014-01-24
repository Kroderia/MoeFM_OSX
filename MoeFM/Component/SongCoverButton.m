//
//  SongCoverButton.m
//  MoeFM
//
//  Created by Kroderia on 1/24/14.
//  Copyright (c) 2014 im.kroderia. All rights reserved.
//

#import "SongCoverButton.h"

@implementation SongCoverButton

- (void)awakeFromNib {
    btnTrackingRectTag = [self addTrackingRect:self.bounds
                                         owner:self
                                      userData:NULL
                                  assumeInside:YES];
}


@end
