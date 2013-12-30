//
//  SongProgressBar.h
//  MoeFM
//
//  Created by Kroderia on 12/22/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SongProgressBar : NSBox

@property (strong) NSBox *loadedProgressView;
@property (strong) NSBox *playedProgressView;


- (void)resetProgress;
- (void)setLoadedWidthOf: (float)rate;
- (void)setPlayedWidthOf: (float)rate;

@end
