//
//  MoefmStatusItem.h
//  MoeFM
//
//  Created by Kroderia on 12/30/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoefmPlayer.h"
#import "EasyNotification.h"

@interface MoefmStatusItem : NSObject<MoefmPlayerDelegate>
{
    NSStatusItem *item;
    int errorCounter;
    int loadtimeoutCounter;
}

@property (weak) MoefmPlayer *moefmPlayer;

- (void)setMenu: (NSMenu*)menu;


@end
