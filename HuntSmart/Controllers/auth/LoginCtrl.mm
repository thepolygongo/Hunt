//
//  LoginCtrl.m
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/15/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "LoginCtrl.h"

@interface LoginCtrl ()

@end

@implementation LoginCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupKeyboard];
    [self.txtUsername addPadding:10];
    [self.txtPassword addPadding:10];
    self.txtUsername.text = @"test@user.com";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self checkImportedImages:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - keyboard handler

- (void)keyboardDidShow {
    if (self.txtUsername.isFirstResponder) {
        [self moveViewForKeyboard:self.txtUsername];
    }
    else if (self.txtPassword.isFirstResponder) {
        [self moveViewForKeyboard:self.txtPassword];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.txtUsername.isFirstResponder) {
        [self.txtPassword becomeFirstResponder];
    }
    else if (self.txtPassword.isFirstResponder) {
        [self.view endEditing:true];
    }
    return false;
}

#pragma mark - view click actions

- (IBAction)onClickBtnLogin:(id)sender {
    if (!validateEmail(self.txtUsername.text)) {
        [self.view makeToast:@"Please input the valid email."];
    }
    else if (self.txtPassword.text.length < 8) {
        [self.view makeToast:@"Password is too short."];
    }
    else {
        CamerasCtrl *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"CamerasCtrl"];
        [self showViewController:ctrl sender:nil];
    }
}

@end
