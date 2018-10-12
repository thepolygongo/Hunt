//
//  CameraCell.h
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/15/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#include <UIKit/UIKit.h>

@interface CameraCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgCamera;
@property (weak, nonatomic) IBOutlet UILabel *lblCameraName;
@property (weak, nonatomic) IBOutlet UILabel *lblModelNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblCameraBrand;

@end
