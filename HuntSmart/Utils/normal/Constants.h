//
//  Constants.h
//  HuntSmart
//
//  Created by Wildlife Management Services on 5/11/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^success)(id response);
typedef void(^failure)(id error);
typedef void(^handler)(NSURLResponse *response, NSData *data, NSError *connectionError);
typedef void(^block)(void);


#define DarkSkySecretKey        @"72144dce9b95aa33b025b55e431ece39"

#define DarkSkyBaseUrl          @"https://api.darksky.net/forecast/"
