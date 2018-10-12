//
//  AnimalLabel.h
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/20/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimalLabel : NSObject

@property (nullable, nonatomic, copy) NSString *labelImage;
@property (nullable, nonatomic, copy) NSString *labelName;
@property (nonatomic) int64_t imageCount;
@property (nullable, nonatomic, copy) NSString *labelSummary;

- (instancetype)initWithName:(NSString *)name image:(NSString *)image summary:(NSString *)summary;

@end
