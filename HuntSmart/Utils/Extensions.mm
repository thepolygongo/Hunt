//
//  Extensions.m
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/15/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "Extensions.h"


@implementation NSObject(Extension)

+ (NSString *)classIdentifier
{
    return NSStringFromClass(self);
}

@end


@implementation UIView(Extension)

@dynamic cornerRadius, borderWidth, borderColor;

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

- (CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

- (UIColor *)borderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

@end


@implementation UITextField(Extension)

- (void)addPadding:(CGFloat)padding
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, padding, self.frame.size.height)];
    self.leftView = paddingView;
    self.rightView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.rightViewMode = UITextFieldViewModeAlways;
}

@end


@implementation NSDate(Extension)

- (NSInteger)hour
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitHour fromDate:self];
    return comps.hour;
}

@end

