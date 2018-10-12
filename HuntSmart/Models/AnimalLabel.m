//
//  AnimalLabel.m
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/20/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "AnimalLabel.h"

@implementation AnimalLabel

- (instancetype)initWithName:(NSString *)name image:(NSString *)image summary:(NSString *)summary
{
    self = [super init];
    if (self) {
        self.labelImage = image;
        self.labelName = name;
        self.labelSummary = summary;
    }
    return self;
}

@end
