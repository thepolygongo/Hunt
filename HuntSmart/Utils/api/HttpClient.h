//
//  HttpClient.h
//  HuntSmart
//
//  Created by Wildlife Management Services on 5/11/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Utils.h"


@interface HttpClient : NSObject

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(success)successBlock failure:(failure)failureBlock;
+ (void)getByHeader:(NSString *)url params:(NSDictionary *)params success:(success)successBlock failure:(failure)failureBlock;
+ (void)getByString:(NSString *)url params:(NSDictionary *)params success:(success)successBlock failure:(failure)failureBlock;
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(success)successBlock failure:(failure)failureBlock;
+ (void)put:(NSString *)url params:(NSDictionary *)params success:(success)successBlock failure:(failure)failureBlock;
+ (void)del:(NSString *)url params:(NSDictionary *)params success:(success)successBlock failure:(failure)failureBlock;

+ (NSDictionary *)getSync:(NSString *)url params:(NSDictionary *)params;
+ (NSDictionary *)postSync:(NSString *)url params:(NSDictionary *)params;
+ (NSDictionary *)putSync:(NSString *)url params:(NSDictionary *)params;
+ (NSDictionary *)delSync:(NSString *)url params:(NSDictionary *)params;

+ (void)postWithUserAgent:(NSString *)url params:(NSDictionary *)params success:(success)successBlock failure:(failure)failureBlock;
+ (void)getImageFromUrl:(NSString*)url handler:(handler)resultBlock;
+ (NSData*)getIamgeFromUrl_Sync:(NSString*)url;

@end
