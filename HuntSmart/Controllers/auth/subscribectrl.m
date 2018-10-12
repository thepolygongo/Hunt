//
//  subscribectrl.m
//  HuntSmart
//
//  Created by Jason Ray on 7/14/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "subscribectrl.h"

@interface subscribectrl ()

@end

@implementation subscribectrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)monthbutton:(id)sender {
    [[MKStoreKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"scmonth"];
}
- (IBAction)seasonbutton:(id)sender {
    [[MKStoreKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"scseason"];
}
- (IBAction)annualbutton:(id)sender {
    [[MKStoreKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"scannual"];
}
- (IBAction)restorebutton:(id)sender {
    [[MKStoreKit sharedKit] restorePurchases];
}


@end
