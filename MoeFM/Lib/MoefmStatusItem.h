//
//  MoefmStatusItem.h
//  MoeFM
//
//  Created by Kroderia on 12/30/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoefmPlayer.h"

@interface MoefmStatusItem : NSObject<MoefmPlayerDelegate>

@property (strong) NSStatusItem *item;

- (void)setMenu: (NSMenu*)menu;

@end
