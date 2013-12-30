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

@property (strong) NSStatusItem *item;
@property int errorCounter;

- (void)setMenu: (NSMenu*)menu;

@end
