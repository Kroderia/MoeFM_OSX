//
//  HttpConnection.h
//  MoeFM
//
//  Created by Kroderia on 12/17/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpConnectionRecvDelegate.h"

@interface HttpConnection : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

+ (NSData*)sendSynchronousRequestTo: (NSString*)url;
+ (NSDictionary*)parseUrlParametersOf: (NSString*)url;
+ (NSDictionary*)dictFrom: (NSData*)json;

- (void)sendAsynchronousRequestTo: (NSString*)url delegate: (id)delegate;

@property (strong) NSMutableData *recvData;
@property (weak) id<HttpConnectionRecvDelegate> delegate;

@end
