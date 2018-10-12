//
//  WelcomeCtrl.m
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/15/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "WelcomeCtrl.h"
#import "MKStoreKit.h"

int activesub = 1;

@interface WelcomeCtrl ()

@end

@implementation WelcomeCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (![[NSUserDefaults standardUserDefaults]
          boolForKey:@"home_instruction"]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Thank You" message:@"Thank You for choosing download WiseEye: Smart Cam. We aim to be the only resource you will ever need for all of your pre-hunt scouting. You will need an Apple compatible SD Card Reader to use along with the app or some other way of getting your trail camera photos to your device. Please read through the instructions on the different screens to get the most out of your experience with the app. Again thank you and enjoy." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"home_instruction"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    NSNumber* expirationmonth =[[MKStoreKit sharedKit] expiryDateForProduct:@"scmonth"];
    if ([[NSDate date] timeIntervalSince1970] > [expirationmonth doubleValue]/1000){
        NSLog(@"SCMonth Expired");
    }else {NSLog (@"SCMonth Active");
        activesub = 1;
        self.subscriptionLbl.text = [NSString stringWithFormat:@"Monthly Subscription Active"];
    }
    
    NSNumber* expsix =[[MKStoreKit sharedKit] expiryDateForProduct:@"scseason"];
    if ([[NSDate date] timeIntervalSince1970] > [expsix doubleValue]/1000){
        NSLog(@"SCSeason Expired");
    }else {NSLog (@"SCSeason Active");
        activesub = 1;
        self.subscriptionLbl.text = [NSString stringWithFormat:@"6 Month Subscription Active"];
    }

    NSNumber* expann =[[MKStoreKit sharedKit] expiryDateForProduct:@"scannual"];
    if ([[NSDate date] timeIntervalSince1970] > [expann doubleValue]/1000){
        NSLog(@"SCAnnual Expired");
    }else {NSLog (@"SCAnnual Active");
        activesub = 1;
        self.subscriptionLbl.text = [NSString stringWithFormat:@"Annual Subscription Active"];
    }
    if (activesub == 0){
        self.subscriptionLbl.text = [NSString stringWithFormat:@"Subscription Required - Please Subscribe"];
    }
}
- (IBAction)enterapp:(id)sender {
    if (activesub == 1){
        CamerasCtrl *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"CamerasCtrl"];
        [self showViewController:ctrl sender:nil];
    } else {
        UIAlertView *pleasesubscribe = [[UIAlertView alloc]
                                        initWithTitle:@"Please Subscribe" message:@"You must have an active subscription to use WiseEye: SmartCam. \n\nPlease use the Subscribe button and either choose a subscription or restore your previous purchase." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [pleasesubscribe show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
