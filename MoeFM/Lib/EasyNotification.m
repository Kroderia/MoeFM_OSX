//
//  EasyNotification.m
//  MoeFM
//
//  Created by Kroderia on 12/25/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import "EasyNotification.h"

static EasyNotification *instance = nil;

@implementation EasyNotification

+ (EasyNotification*)instance {
    if (! instance) {
        instance = [[super allocWithZone:NULL] init];
    }
    
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self instance];
}

- (id)copyWithZone:(NSZone*)zone {
    return instance;
}

- (id)init {
    if (instance) {
        return instance;
    }
    
    self = [super init];
    
    if (self) {
        self.center = [NSUserNotificationCenter defaultUserNotificationCenter];
    }
    
    return self;
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
    return YES;
}

- (BOOL)shouldUseNotification {
    return ([[NSUserDefaults standardUserDefaults] boolForKey:@"useNotification"] == NSOnState);
}


- (void)sendNotificationWithTitle: (NSString*)title Message: (NSString*)message {
    if (! [self shouldUseNotification]) {
        return;
    }
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = title;
    notification.informativeText = message;
    
    [self.center setDelegate:self];
    [self.center deliverNotification:notification];
}

@end
