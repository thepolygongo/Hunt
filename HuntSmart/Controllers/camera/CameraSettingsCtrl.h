//
//  CameraSettingsCtrl.h
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/15/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//


#import <CoreLocation/CoreLocation.h>
#import "BaseCtrl.h"
#import "GMSViewController.h"
@protocol CameraChangeDelegate <NSObject>

- (void)cameraChanged:(CameraModel *)camera;

@end

@interface CameraSettingsCtrl : BaseCtrl <UITextFieldDelegate, UITextViewDelegate, CLLocationManagerDelegate, GMSViewControllerDelegate > {
    
    CLLocationManager *locationManager;
    
    CLLocationCoordinate2D coordinateInCurrent;
    CLLocationCoordinate2D coordinateInMapView;
    CLLocationCoordinate2D coordinateInManualInput;
}

@property (weak, nonatomic) id <CameraChangeDelegate> delegate;
@property (strong, nonatomic) CameraModel *mCamera;

@property (weak, nonatomic) IBOutlet UITextField *txtCameraName;
@property (weak, nonatomic) IBOutlet UITextField *txtBrand;
@property (weak, nonatomic) IBOutlet UITextField *txtModelNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtNotes;

@property (weak, nonatomic) IBOutlet UIView *inputContainer;
@property (weak, nonatomic) IBOutlet UITextField *txtLatitude;
@property (weak, nonatomic) IBOutlet UITextField *txtLongitude;


@end
