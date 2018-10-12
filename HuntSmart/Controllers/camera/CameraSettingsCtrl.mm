//
//  CameraSettingsCtrl.m
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/15/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "CameraSettingsCtrl.h"
//#import "HuntSmart-Swift.h"
#import "GMSViewController.h"

@interface CameraSettingsCtrl ()

@end

@implementation CameraSettingsCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(self.mCamera.latitude, self.mCamera.longitude);
    coordinateInMapView = location;
    coordinateInManualInput = location;
    
    // setup elements
    [self setupKeyboard];
    [self.txtCameraName addPadding:10];
    [self.txtBrand addPadding:10];
    [self.txtModelNumber addPadding:10];
    [self.txtLatitude addPadding:10];
    [self.txtLongitude addPadding:10];
    
//    [self initCLLocationManager];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
//        [locationManager requestWhenInUseAuthorization];
//    [locationManager startUpdatingLocation];
    
    // set camera settings value in UI
    
    self.txtCameraName.text = self.mCamera.cameraName;
    self.txtBrand.text = self.mCamera.brand;
    self.txtModelNumber.text = self.mCamera.modelNumber;
    self.txtNotes.text = self.mCamera.notes;
    
    // camera location
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.mCamera.latitude, self.mCamera.longitude);
    [self showCameraLocationValue:coordinate];
}

#pragma mark - custom methods

- (BOOL)isNumber:(NSString *)string {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES '^[-+]?[0-9]*.?[0-9]+$'"];
    BOOL isNumeric = [predicate evaluateWithObject:string];
    return isNumeric;
}


- (void)showCameraLocationValue:(CLLocationCoordinate2D)coordinate {
    self.txtLatitude.text = [NSString stringWithFormat:@"%.4f", coordinate.latitude];
    self.txtLongitude.text = [NSString stringWithFormat:@"%.4f", coordinate.longitude];
}
    
- (void) returnLocation: (double) latitute second:(double) longitude{
    self.txtLatitude.text = [NSString stringWithFormat:@"%.4f", latitute];
    self.txtLongitude.text = [NSString stringWithFormat:@"%.4f", longitude];
}
    
- (IBAction)clickGoogleMap:(UIButton *)sender {
    GMSViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"idGMSVC"];
    vc.delegate = self;
    
    CLLocationCoordinate2D coor;
    coor.latitude = [self.txtLatitude.text floatValue];
    coor.longitude = [self.txtLongitude.text floatValue];
    
    vc.coordinate = coor;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
    

#pragma mark - keyboard handler

- (void)keyboardDidShow {
    if (self.txtCameraName.isFirstResponder) {
        [self moveViewForKeyboard:self.txtCameraName];
    }
    else if (self.txtBrand.isFirstResponder) {
        [self moveViewForKeyboard:self.txtBrand];
    }
    else if (self.txtModelNumber.isFirstResponder) {
        [self moveViewForKeyboard:self.txtModelNumber];
    }
    else if (self.txtNotes.isFirstResponder) {
        [self moveViewForKeyboard:self.txtNotes];
    }
    else if (self.txtLatitude.isFirstResponder) {
        [self moveViewForKeyboard:self.txtLatitude];
    }
    else if (self.txtLongitude.isFirstResponder) {
        [self moveViewForKeyboard:self.txtLongitude];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.txtCameraName.isFirstResponder) {
        [self.txtBrand becomeFirstResponder];
    }
    else if (self.txtBrand.isFirstResponder) {
        [self.txtModelNumber becomeFirstResponder];
    }
    else if (self.txtModelNumber.isFirstResponder) {
        [self.txtNotes becomeFirstResponder];
    }
    return false;
}

#pragma mark - view click actions

- (IBAction)onClickBtnChange:(id)sender {
    if (self.delegate != nil) {
        if (![self isNumber:self.txtLatitude.text] || ![self isNumber:self.txtLongitude.text])
            return;
        
        
        float la = [self.txtLatitude.text floatValue];
        float lo = [self.txtLongitude.text floatValue];
        
        self.mCamera.latitude = la;
        self.mCamera.longitude = lo;
        
        self.mCamera.cameraName = self.txtCameraName.text;
        self.mCamera.brand = self.txtBrand.text;
        self.mCamera.modelNumber = self.txtModelNumber.text;
        self.mCamera.notes = self.txtNotes.text;
        
        if ([CoreDataModel.sharedInstance saveData]) {
            [locationManager stopUpdatingLocation];
            [self.delegate cameraChanged:self.mCamera];
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }
}


#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    coordinateInCurrent = locations[0].coordinate;
    
    [self showCameraLocationValue:coordinateInCurrent];
}


@end
