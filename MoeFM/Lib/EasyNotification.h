//
//  EasyNotification.h
//  MoeFM
//
//  Created by Kroderia on 12/25/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EasyNotification : NSObject<NSUserNotificationCenterDelegate>

@property (weak) NSUserNotificationCenter *center;

+ (EasyNotification*)instance;
- (void)sendNotificationWithTitle: (NSString*)title Message: (NSString*)message;

@end
