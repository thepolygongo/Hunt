//
//  MenuRowView.m
//  HuntSmart
//
//  Created by Wildlife Management Services on 5/5/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "MenuRowView.h"

@implementation MenuRowView

- (void)setText:(NSString *)text {
    _text = text;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width-10, self.frame.size.height)];
    
    label.contentMode = UIViewContentModeCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.text = self.text;
    
    [self addSubview:label];
}

@end
