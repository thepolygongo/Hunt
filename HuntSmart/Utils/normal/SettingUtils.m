//
//  SettingUtils.m
//  HuntSmart
//
//  Created by Wildlife Management Services on 5/11/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "SettingUtils.h"

@implementation SettingUtils

+ (void)saveValue:(id)value forKey:(NSString *)key {
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.smartcam"];
    [shared setObject:value forKey:key];
    [shared synchronize];
}

+ (id)getValueForKey:(NSString *)key {
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.smartcam"];
    return [shared objectForKey:key];
}

+ (void)saveLastImageID:(int)lastImageID {
    [self saveValue:[NSNumber numberWithInt:lastImageID] forKey:@"LastImageID"];
}

+ (int)lastImageID {
    id value = [self getValueForKey:@"LastImageID"];
    if (value == nil) {
        return -1;
    }
    else {
        return [value intValue];
    }
}

@end
