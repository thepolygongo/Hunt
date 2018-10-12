//
//  HttpClient.m
//  HuntSmart
//
//  Created by Wildlife Management Services on 5/11/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "HttpClient.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking_Synchronous/AFHTTPSessionManager+Synchronous.h>

@implementation HttpClient

+ (AFHTTPSessionManager *)AFHttpSessionManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer = responseSerializer;
    
    return manager;
}

// GET Request
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(success)successBlock failure:(failure)failureBlock
{
    AFHTTPSessionManager *manager = [HttpClient AFHttpSessionManager];
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        if (successBlock)
        successBlock(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if (failureBlock)
        failureBlock(error);
    }];
}

// GET Request
+ (void)getByHeader:(NSString *)url params:(NSDictionary *)params success:(success)successBlock failure:(failure)failureBlock
{
    AFHTTPSessionManager *manager = [HttpClient AFHttpSessionManager];
    NSSet* contentTypesSet = manager.responseSerializer.acceptableContentTypes;
    NSMutableSet* contentTypes = [[NSMutableSet alloc] initWithSet:contentTypesSet];
    [contentTypes addObject:@"text/html"];
    [contentTypes addObject:@"text/xml"];
    manager.responseSerializer.acceptableContentTypes = contentTypes;
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        if (successBlock)
        successBlock(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if (failureBlock)
        failureBlock(error);
    }];
}

+ (void)getByString:(NSString *)url params:(NSDictionary *)params success:(success)successBlock failure:(failure)failureBlock
{
    AFHTTPSessionManager *manager = [HttpClient AFHttpSessionManager];
    
    AFJSONRequestSerializer* serializer = [AFJSONRequestSerializer serializer];
    [serializer setStringEncoding:NSUTF8StringEncoding];
    manager.requestSerializer = serializer;
    
    NSSet* contentTypesSet = manager.responseSerializer.acceptableContentTypes;
    NSMutableSet* contentTypes = [[NSMutableSet alloc] initWithSet:contentTypesSet];
    [contentTypes addObject:@"text/html"];
    [contentTypes addObject:@"text/xml"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = contentTypes;
    
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        if (successBlock)
        successBlock(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if (failureBlock)
        failureBlock(error);
    }];
}

+ (NSDictionary *)getSync:(NSString *)url params:(NSDictionary *)params {
    AFHTTPSessionManager *manager = [HttpClient AFHttpSessionManager];
    NSError *error = nil;
    NSData *result = [manager syncGET:url parameters:params task:nil error:&error];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:&error];
    return dict;
}

// POST Request
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(success)successBlock failure:(failure)failureBlock {
    
    AFHTTPSessionManager *manager = [HttpClient AFHttpSessionManager];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        if (successBlock)
        successBlock(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if (failureBlock)
        failureBlock(error);
    }];
}

// POST Request with user-agent
+ (void)postWithUserAgent:(NSString *)url params:(NSDictionary *)params success:(success)successBlock failure:(failure)failureBlock
{
    AFHTTPSessionManager *manager = [HttpClient AFHttpSessionManager];
    // request header
    [manager.requestSerializer setValue:@"dcinside.castapp" forHTTPHeaderField:@"User-Agent"];
    // response header
    NSSet* contentTypesSet = manager.responseSerializer.acceptableContentTypes;
    NSMutableSet* contentTypes = [[NSMutableSet alloc] initWithSet:contentTypesSet];
    [contentTypes addObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = contentTypes;
    
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        if (successBlock)
        successBlock(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if (failureBlock)
        failureBlock(error);
    }];
}

+ (NSDictionary *)postSync:(NSString *)url params:(NSDictionary *)params {
    AFHTTPSessionManager *manager = [HttpClient AFHttpSessionManager];
    NSError *error = nil;
    NSData *result = [manager syncPOST:url parameters:params task:nil error:&error];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:&error];
    return dict;
}

// PUT Request
+ (void)put:(NSString *)url params:(NSDictionary *)params success:(success)successBlock failure:(failure)failureBlock
{
    AFHTTPSessionManager *manager = [HttpClient AFHttpSessionManager];
    [manager PUT:url parameters:params success:^(NSURLSessionTask *task, id responseObject) {
        if (successBlock)
        successBlock(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if (failureBlock)
        failureBlock(error);
    }];
}

+ (NSDictionary *)putSync:(NSString *)url params:(NSDictionary *)params {
    AFHTTPSessionManager *manager = [HttpClient AFHttpSessionManager];
    NSError *error = nil;
    NSData *result = [manager syncPUT:url parameters:params task:nil error:&error];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:&error];
    return dict;
}

// DELETE Request
+ (void)del:(NSString *)url params:(NSDictionary *)params success:(success)successBlock failure:(failure)failureBlock
{
    AFHTTPSessionManager *manager = [HttpClient AFHttpSessionManager];
    [manager DELETE:url parameters:params success:^(NSURLSessionTask *task, id responseObject) {
        if (successBlock)
        successBlock(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if (failureBlock)
        failureBlock(error);
    }];
}

+ (NSDictionary *)delSync:(NSString *)url params:(NSDictionary *)params {
    AFHTTPSessionManager *manager = [HttpClient AFHttpSessionManager];
    NSError *error = nil;
    NSData *result = [manager syncDELETE:url parameters:params task:nil error:&error];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:&error];
    return dict;
}

+ (void)getImageFromUrl:(NSString*)url handler:(handler)resultBlock {
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [request setValue:@"http://dccon.dcinside.com/" forHTTPHeaderField:@"Referer"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        resultBlock(response, data, connectionError);
    }];
}

+ (NSData*)getIamgeFromUrl_Sync:(NSString*)url {
    //    NSString *url = @"http://dcimg5.dcinside.com/dccon.php?no=62b5df2be09d3ca567b1c5bc12d46b394aa3b1058c6e4d0ca41648b65de22c6ed69eccce0ee50da13e6038ac232fe2312f1f0566b809c773cbf72511b4d1142ba30f";
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    NSURLResponse* response;
    NSError* error = nil;
    
    [request setValue:@"http://dccon.dcinside.com/" forHTTPHeaderField:@"Referer"];
    
    return [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
}

@end
