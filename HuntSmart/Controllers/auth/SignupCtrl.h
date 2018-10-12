//
//  SignupCtrl.h
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/15/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "BaseCtrl.h"
#import "CamerasCtrl.h"
#import "SettingUtils.h"

@interface SignupCtrl : BaseCtrl <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;

@end
