//
//  NetworkUtils.h
//  HuntSmart
//
//  Created by Wildlife Management Services on 5/11/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "HttpClient.h"


@interface NetworkUtils : NSObject

+ (void)getWeatherAt:(int)time in:(CLLocationCoordinate2D)location success:(success)successBlock failure:(failure)failureBlock;

@end
