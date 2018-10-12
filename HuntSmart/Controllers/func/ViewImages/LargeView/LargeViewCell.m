//
//  LargeViewCell.m
//  HuntSmart
//
//  Created by Wildlife Management Services on 5/9/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "LargeViewCell.h"

@implementation LargeViewCell

- (IBAction)onClickClose:(id)sender {
    if (self.delegate != nil) {
        [self.delegate onClickLargeViewCellClose:self];
    }
}

- (IBAction)onClickImage:(id)sender {
    if (self.delegate != nil) {
        [self.delegate onClickLargeViewCellImage:self];
    }
}

@end
