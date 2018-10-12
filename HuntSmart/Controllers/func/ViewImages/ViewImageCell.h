//
//  ViewImageCell.h
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/18/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewImageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgAnimal;
@property (weak, nonatomic) IBOutlet UILabel *lblCaptureDate;
@property (weak, nonatomic) IBOutlet UILabel *lblImageName;

@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btnInstagram;
@property (weak, nonatomic) IBOutlet UIButton *btnEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnMove;

@end
