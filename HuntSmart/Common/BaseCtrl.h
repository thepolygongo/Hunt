//
//  BaseCtrl.h
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/15/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#include <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#include "Toast.h"
#include <CoreData/CoreData.h>

#import "predict_image.h"
#import "Extensions.h"
#import "Utils.h"
#import "ImageModel+CoreDataProperties.h"

@interface BaseCtrl : UIViewController <UIGestureRecognizerDelegate>

@property (assign, nonatomic) CGFloat keybaordHeight;
@property (nonatomic) MBProgressHUD *progressHUD;

- (void)runInMainQueue:(block)block;
- (void)run:(block)block afterDelay:(double)delayInSeconds;
- (void)runAsync:(block)block afterDelay:(double)delayInSeconds;
- (void)runInBackground:(block)block afterDelay:(double)delayInSeconds;

- (void)showProgress:(NSString *)message;
- (void)hideProgress;

- (void)setupKeyboard;
- (void)moveViewForKeyboard:(UIView *)textField;

- (void)checkImportedImages:(NSNotification *)notification;

@end
