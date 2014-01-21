//
//  MoefmApiDelegate.h
//  MoeFM
//
//  Created by Kroderia on 12/21/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MoefmApiDelegate <NSObject>

@required
- (void)recvApiData: (id)data Error: (NSDictionary*)error;

@end
