//
//  MoefmApi.m
//  MoeFM
//
//  Created by Kroderia on 12/17/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import "MoefmApi.h"
#import "HttpConnection.h"


@implementation MoefmApi

@synthesize delegate;

//==========================================
// HttpConnectionRecvDelegate
- (void)recvData:(NSData *)data {
    [self performSelector:todo withObject:data];
}

- (id)init {
    self = [super init];
    if (self) {
        NSPropertyListFormat *plistFormat = nil;
        NSString *errorDesc = nil;
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MoeFM-Api" ofType:@"plist"];
        NSData *plistData = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        plistDict = (NSDictionary*)[NSPropertyListSerialization propertyListFromData:plistData
                                                                    mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                                              format:plistFormat
                                                                    errorDescription:&errorDesc];
        
        apiKey = [plistDict objectForKey:@"apiKey"];
    }
    
    return self;
}

//==========================================
// User authorize control
+ (BOOL)isAuthorized {
    return ([[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"] != nil);
}

+ (void)clearAuthorized {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"accessToken"];
    [ud removeObjectForKey:@"accessTokenSecret"];
}

//==========================================
// Network/Action error checking
- (NSDictionary*)checkIsError: (NSDictionary*)recvDict {
    if (recvDict == nil) {
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:101], @"code", [NSNumber numberWithInt:1], @"retry", @"接收数据失败", @"title", @">_<网络可能出错了", @"message", nil];
    }
    
    NSDictionary *errorDict = [[recvDict objectForKey:@"response"] objectForKey:@"error"];
    NSDictionary *result;
    
    if (errorDict != nil) {
        if ([[errorDict objectForKey:@"code"] integerValue] == 401) {
            result = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:401], @"code", [NSNumber numberWithInt:0], @"retry", @"认证错误", @"title", @"你的授权可能已失效, 请重新授权", @"message", nil];
        } else {
            result = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:911], @"code", [NSNumber numberWithInt:1], @"retry", @"未知错误", @"title", [NSString stringWithFormat:@"发生了未知错误, 错误码: %@", [errorDict objectForKey:@"code"]], @"message", nil];
        }
    } else if ([[[[recvDict objectForKey:@"response"] objectForKey:@"information"] objectForKey:@"has_error"] boolValue] == YES) {
        result = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:102], @"code", [NSNumber numberWithInt:1], @"retry", @"未知错误", @"message", @"接收数据存在未知错误", @"title", nil];
    } else {
        result = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:100], @"code", nil];
    }
    
    return result;
}

//==========================================
// Oauth method
- (void)request {
    todo = @selector(parseOauthInfoFromData:);
    
    NSString *theUrl = [plistDict objectForKey:@"requestUrl"];
    HttpConnection *theConnection = [[HttpConnection alloc] init];
    [theConnection sendAsynchronousRequestTo:theUrl delegate:self];
}


- (void)accessWithRequestToken: (NSString*)token RequestTokenSecret: (NSString*)secret Verifier: (NSString*)verifier {
    todo = @selector(parseOauthInfoFromData:);
    
    NSString *theUrl = [NSString stringWithFormat:@"%@?request_token=%@&request_token_secret=%@&verifier=%@", [plistDict objectForKey:@"accessUrl"], token, secret, verifier];
    HttpConnection *theConnection = [[HttpConnection alloc] init];
    [theConnection sendAsynchronousRequestTo:theUrl delegate:self];
}


//==========================================
// Parser
- (void)parseOauthInfoFromData: (NSData*)data {
    NSDictionary *recvDict = [HttpConnection dictFrom:data];
    NSDictionary *resultDict;
    
    NSDictionary *error = [self checkIsError:recvDict];
    if ([[error objectForKey:@"code"] integerValue] == 100) {
        resultDict = [recvDict objectForKey:@"info"];
    } else {
        resultDict = nil;
    }
    
    [self.delegate recvApiData:resultDict Error:error];
}

- (void)parsePlaylistInfoFromData: (NSData*)data {
    NSDictionary *recvDict = [HttpConnection dictFrom:data];
    NSDictionary *resultDict;
    
    NSDictionary *error = [self checkIsError:recvDict];
    if ([[error objectForKey:@"code"] integerValue] == 100) {
        resultDict = [[recvDict objectForKey:@"response"] objectForKey:@"playlist"];
    } else {
        resultDict = nil;
    }
    
    [self.delegate recvApiData:resultDict Error:error];
}

- (void)parseStandardApiInfoFromData: (NSData*)data {
    NSDictionary *recvDict = [HttpConnection dictFrom:data];
    NSDictionary *resultDict;
    
    NSDictionary *error = [self checkIsError:recvDict];
    if ([[error objectForKey:@"code"] integerValue] == 100) {
        resultDict = [recvDict objectForKey:@"response"];
    } else {
        resultDict = nil;
    }
    
    [self.delegate recvApiData:resultDict Error:error];
}

//==========================================
// Call MoeFM API
- (void)getPlaylist {
    [self getPlaylistOf:1];
}

- (void)getPlaylistOf:(int)count {
    todo = @selector(parsePlaylistInfoFromData:);
    NSString *theUrl;
    
    if ([MoefmApi isAuthorized]) {
        theUrl = [NSString stringWithFormat:@"%@?url=%@&api_key=%@&api=json&perpage=%d&%@", [plistDict objectForKey:@"ogetUrl"], [plistDict objectForKey:@"playlistApiUrl"], apiKey, count, [self oauthString]];
    } else {
        theUrl = [NSString stringWithFormat:@"%@?url=%@&api_key=%@&api=json&perpage=%d", [plistDict objectForKey:@"getUrl"], [plistDict objectForKey:@"playlistApiUrl"], apiKey, count];
    }
    
    HttpConnection *theConnection = [[HttpConnection alloc] init];
    [theConnection sendAsynchronousRequestTo:theUrl delegate:self];
}

- (void)addFavSongBySubId:(int)subId {
    [self sendFavRequestAction:@"add" Type:1 SubId:subId];
}

- (void)deleteFavSongBySubId:(int)subId {
    [self sendFavRequestAction:@"delete" Type:1 SubId:subId];
}

- (void)addTrashSongBySubId:(int)subId {
    [self sendFavRequestAction:@"add" Type:2 SubId:subId];
}

- (void)logListenToSubId: (int)subId {
    todo = @selector(parseStandardApiInfoFromData:);

    NSString *theUrl = [NSString stringWithFormat:@"%@?url=%@&%@&obj_id=%d", [plistDict objectForKey:@"ogetUrl"], [plistDict objectForKey:@"logListenApiUrl"], [self oauthString], subId];
    
    HttpConnection *theConnection = [[HttpConnection alloc] init];
    [theConnection sendAsynchronousRequestTo:theUrl delegate:self];
}

- (void)sendFavRequestAction: (NSString*)action Type: (int)type SubId: (int)subId {
    todo = @selector(parseStandardApiInfoFromData:);
    
    NSString *ogetUrl = [plistDict objectForKey:@"ogetUrl"];
    NSString *apiUrl = [plistDict objectForKey:[NSString stringWithFormat:@"%@FavApiUrl", action]];
    NSString *theUrl = [NSString stringWithFormat:@"%@?url=%@&%@&fav_obj_type=song&fav_type=%d&fav_obj_id=%d", ogetUrl, apiUrl, [self oauthString], type, subId];
    
    HttpConnection *theConnection = [[HttpConnection alloc] init];
    [theConnection sendAsynchronousRequestTo:theUrl delegate:self];
}


//==========================================
// Params constructor
- (NSString*)oauthString {
    return [NSString stringWithFormat:@"access_token=%@&access_token_secret=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"], [[NSUserDefaults standardUserDefaults] objectForKey:@"accessTokenSecret"]];
}

@end






















