//
//  CameraAddCtrl.h
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/15/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "BaseCtrl.h"
#import "GMSViewController.h"

@protocol CameraAddDelegate <NSObject>

- (void)cameraAdded:(CameraModel *)camera;

@end

@interface CameraAddCtrl : BaseCtrl <UITextFieldDelegate, UITextViewDelegate, CLLocationManagerDelegate, GMSViewControllerDelegate > {
    
    CLLocationManager *locationManager;
}

@property (weak, nonatomic) id <CameraAddDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *txtCameraName;
@property (weak, nonatomic) IBOutlet UITextField *txtBrand;
@property (weak, nonatomic) IBOutlet UITextField *txtModelNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtNotes;


@property (weak, nonatomic) IBOutlet UIView *inputContainer;
@property (weak, nonatomic) IBOutlet UITextField *txtLatitude;
@property (weak, nonatomic) IBOutlet UITextField *txtLongitude;

@end
