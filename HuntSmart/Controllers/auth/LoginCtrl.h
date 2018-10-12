//
//  LoginCtrl.h
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/15/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#include <UIKit/UIKit.h>

#import "BaseCtrl.h"
#import "CamerasCtrl.h"

@interface LoginCtrl : BaseCtrl <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@end
