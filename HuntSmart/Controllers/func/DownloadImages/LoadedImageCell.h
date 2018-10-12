//
//  LoadedImageCell.h
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/18/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadedImageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgAnimal;
@property (weak, nonatomic) IBOutlet UILabel *lblAnimalLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblCaptureDate;
@property (weak, nonatomic) IBOutlet UILabel *lblImageName;

@end
