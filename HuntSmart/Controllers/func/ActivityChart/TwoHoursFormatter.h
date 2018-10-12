//
//  TwoHoursFormatter.h
//  HuntSmart
//
//  Created by Wildlife Management Services on 5/8/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Charts/Charts-Swift.h>

@interface TwoHoursFormatter : NSObject <IChartAxisValueFormatter>

+ (NSString *)twoHoursString:(int)fromHour;

@end
