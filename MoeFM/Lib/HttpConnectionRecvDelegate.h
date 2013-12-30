//
//  HttpConnectionRecvDelegate.h
//  MoeFM
//
//  Created by Kroderia on 12/21/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HttpConnectionRecvDelegate <NSObject>

@required
- (void)recvData: (NSData*)data;

@end
