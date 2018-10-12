//
//  Extensions.h
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/15/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>


@interface NSObject(Extension)

+ (NSString *)classIdentifier;

@end


@interface UIView(Extension)

@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;

@end


@interface UITextField(Extension)

- (void)addPadding:(CGFloat)padding;

@end


@interface NSDate(Extension)

- (NSInteger)hour;

@end

