//
//  HttpConnection.m
//  MoeFM
//
//  Created by Kroderia on 12/17/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import "HttpConnection.h"

@implementation HttpConnection

@synthesize recvData;

+ (NSData*)sendSynchronousRequestTo:(NSString *)url {
    NSURL *theUrl = [NSURL URLWithString:url];
    NSURLRequest *theRequest = [[NSURLRequest alloc] initWithURL:theUrl
                                                     cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                 timeoutInterval:5.0f];
    NSData *recvData = [NSURLConnection sendSynchronousRequest:theRequest
                                             returningResponse:nil
                                                         error:nil];
    return recvData;
}

- (void)sendAsynchronousRequestTo:(NSString *)url delegate: (id)delegate {
    NSURL *theUrl = [NSURL URLWithString:url];
    NSURLRequest *theRequest = [[NSURLRequest alloc] initWithURL:theUrl
                                                     cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                 timeoutInterval:10.0f];
    
    [self createConnectionWithRequest:theRequest delegate:delegate];
}

- (NSURLResponse*)sendSynchronousHeadRequestTo: (NSString*)url {
    NSURL *theUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theUrl
                                                              cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                          timeoutInterval:10.0f];
    [theRequest setHTTPMethod:@"HEAD"];
    [theRequest setValue:@"MacfmMp3PlayerUserAgent/1.0" forHTTPHeaderField:@"User-Agent"];
    
    NSURLResponse *result;
    [NSURLConnection sendSynchronousRequest:theRequest
                          returningResponse:&result
                                      error:nil];
    return result;
}

- (void)createConnectionWithRequest: (NSURLRequest*)request delegate: (id)delegate {
    self.delegate = delegate;
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request
                                                                     delegate:self
                                                             startImmediately:YES];
    
    if (theConnection) {
        self.recvData = [[NSMutableData alloc] init];
    }
}


+ (NSDictionary*)parseUrlParametersOf: (NSString*)query {
    NSArray *components = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    for (NSString *component in components) {
        NSArray *subcomponents = [component componentsSeparatedByString:@"="];
        [parameters setObject:[[subcomponents objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                       forKey:[[subcomponents objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return parameters;
}



+ (NSDictionary*)dictFrom:(NSData *)json {
    if (json == nil) {
        return nil;
    }
    
    NSError *error;
    NSDictionary *recvDict = [NSJSONSerialization JSONObjectWithData:json
                                                             options:kNilOptions
                                                               error:&error];
    if (error == nil) {
        return recvDict;
    } else {
        return nil;
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.recvData appendData:data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.recvData = nil;
    NSLog(@"%@", error);
    [self.delegate recvData:self.recvData];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if ([self.delegate respondsToSelector:@selector(recvResponse:)]) {
        [self.delegate recvResponse:response];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.delegate recvData:self.recvData];
}


@end
