//
//  Utils.h
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/15/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "Constants.h"
#import "CoreDataModel.h"
#import "SettingUtils.h"


BOOL validateEmail(NSString* checkString);

NSString* getDateTimeStringFromDate(NSDate* date);
NSDate* getDateFromDateTimeString(NSString* dateString);

NSString* getTimeStringFor2Hours(NSDate* fromDate);
NSString* getTimeStringFor4Hours(NSDate* fromDate);

NSString* getDateStringFromDate(NSDate* date);
NSDate* getDateFromDateString(NSString* dateString);

id getResourcesFromPlist(NSString* plistFile, NSString* key);


static inline void delay(NSTimeInterval delay, dispatch_block_t block) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

static UIColor * UIColorWithHexString(NSString *hex) {
    unsigned int rgb = 0;
    [[NSScanner scannerWithString:
      [[hex uppercaseString] stringByTrimmingCharactersInSet:
       [[NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEF"] invertedSet]]]
     scanHexInt:&rgb];
    return [UIColor colorWithRed:((CGFloat)((rgb & 0xFF0000) >> 16)) / 255.0
                           green:((CGFloat)((rgb & 0xFF00) >> 8)) / 255.0
                            blue:((CGFloat)(rgb & 0xFF)) / 255.0
                           alpha:1.0];
}
