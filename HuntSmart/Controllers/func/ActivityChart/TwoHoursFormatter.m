//
//  TwoHoursFormatter.m
//  HuntSmart
//
//  Created by Wildlife Management Services on 5/8/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "TwoHoursFormatter.h"

@interface TwoHoursFormatter () {
}

@end

@implementation TwoHoursFormatter

- (id)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

+ (NSString *)twoHoursString:(int)fromHour {
    int toHour = fromHour + 2;
    
    return [NSString stringWithFormat:@"%@-%@", [self timeString:fromHour], [self timeString:toHour]];
}

+ (NSString *)timeString:(int)hour {
    if (hour < 0 && hour > 24) {
        return @"";
    }
    else if (hour == 0) {
        return @"12AM";
    }
    else if (hour == 12) {
        return @"12PM";
    }
    else if (hour == 24) {
        return @"11:59PM";
    }
    else if (hour < 12) {
        return [NSString stringWithFormat:@"%dAM", hour];
    }
    else {
        return [NSString stringWithFormat:@"%dPM", hour-12];
    }
}

- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis {
    int realValue = 22 - value;
    return [TwoHoursFormatter twoHoursString:realValue];
}

@end
