//
//  DataNotifyReceiver.h
//  MoeFM
//
//  Created by Kroderia on 12/28/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataNotifyReceiver <NSObject>

@required
- (void)recvData: (id)data;

@end
