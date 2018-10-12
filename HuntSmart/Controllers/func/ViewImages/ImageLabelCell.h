//
//  ImageLabelCell.h
//  HuntSmart
//
//  Created by Oyundolger Hataanbold on 3/19/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageLabelCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;

@end
