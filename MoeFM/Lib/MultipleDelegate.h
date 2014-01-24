//
//  MultipleDelegate.h
//  MoeFM
//
//  Created by Kroderia on 1/24/14.
//  Copyright (c) 2014 im.kroderia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MultipleDelegate <NSObject>

@required
@property (strong) NSMutableArray *delegate;
- (void)addDelegate: (id)delegate;
- (void)removeDelegate: (id)delegate;

@optional
- (void)delegatePerformOptionalSelector: (SEL)selector;
- (void)delegatePerformOptionalSelector: (SEL)selector Data: (id)data;
- (void)delegateAddObserverWithSelector: (SEL)selector Name: (id)name;
- (void)delegateAddTimeObserverWithSelector: (SEL)selector Timer: (CMTime)timer;

@end
