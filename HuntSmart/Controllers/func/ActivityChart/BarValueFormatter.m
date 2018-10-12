//
//  BarValueFormatter.m
//  HuntSmart
//
//  Created by Wildlife Management Services on 5/18/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "BarValueFormatter.h"

@implementation BarValueFormatter

- (NSString *)stringForValue:(double)value entry:(ChartDataEntry * _Nonnull)entry dataSetIndex:(NSInteger)dataSetIndex viewPortHandler:(ChartViewPortHandler * _Nullable)viewPortHandler {
    if (entry.y <= 0) {
        return @"";
    }
    return [NSString stringWithFormat:@"%d", (int)entry.y];
}

@end
