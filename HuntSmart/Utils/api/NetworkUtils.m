//
//  NetworkUtils.m
//  HuntSmart
//
//  Created by Wildlife Management Services on 5/11/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "NetworkUtils.h"

@implementation NetworkUtils

+ (void)getWeatherAt:(int)time in:(CLLocationCoordinate2D)location success:(success)successBlock failure:(failure)failureBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@/%f,%f,%d?exclude=hourly,flags", DarkSkyBaseUrl, DarkSkySecretKey, location.latitude, location.longitude, time];
    [HttpClient get:url params:nil success:successBlock failure:failureBlock];
}

@end
