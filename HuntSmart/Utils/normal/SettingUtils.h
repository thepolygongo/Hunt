//
//  SettingUtils.h
//  HuntSmart
//
//  Created by Wildlife Management Services on 5/11/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingUtils : NSObject

+ (void)saveValue:(id)value forKey:(NSString *)key;
+ (id)getValueForKey:(NSString *)key;

+ (void)saveLastImageID:(int)lastImageID;
+ (int)lastImageID;

@end
