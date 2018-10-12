//
//  CameraAddCtrl.m
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/15/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "CameraAddCtrl.h"
#import "GMSViewController.h"

@interface CameraAddCtrl ()

@end

@implementation CameraAddCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // call setup methods
    
    [self setupUISettings];
    [self initCLLocationManager];
    if (![[NSUserDefaults standardUserDefaults]
          boolForKey:@"camsetup2_instruction"]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Instructions" message:@"Please enter the name and location of the camera. All other information is optional. You can either use your current location, enter the coordinates from another GPS unit or select your current location on the map by pressing and holding on the marker pin to move it on the map to the correct location. " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"camsetup2_instruction"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
    
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"gotoGMSMap"]){
        GMSViewController *vc = [segue destinationViewController];
        vc.delegate = CameraAddCtrl.self;
    }
}
 
    - (void) returnLocation: (double) latitude second:(double) longitude{
        self.txtLatitude.text = [NSString stringWithFormat:@"%.3f", latitude];
        self.txtLongitude.text = [NSString stringWithFormat:@"%.3f", longitude];
    }
    
- (IBAction)googleMap:(UIButton *)sender {
    GMSViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"idGMSVC"];
    vc.delegate = self;
    
    CLLocationCoordinate2D coor;
    coor.latitude = [self.txtLatitude.text floatValue];
    coor.longitude = [self.txtLongitude.text floatValue];
    
    vc.coordinate = coor;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
    
- (void)setupUISettings {
    // setup elements
    
    [self setupKeyboard];
    [self.txtCameraName addPadding:10];
    [self.txtBrand addPadding:10];
    [self.txtModelNumber addPadding:10];
    [self.txtLatitude addPadding:10];
    [self.txtLongitude addPadding:10];
    
    // Set up dropdown menu loaded from storyboard
    // Note that `dataSource` and `delegate` outlets are connected in storyboard
    
}

- (void)initCLLocationManager {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
}

#pragma mark - custom methods

- (BOOL)isNumber:(NSString *)string {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES '^[-+]?[0-9]*.?[0-9]+$'"];
    BOOL isNumeric = [predicate evaluateWithObject:string];
    return isNumeric;
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

- (IBAction)onClickBtnSave:(id)sender {
    if (self.delegate != nil) {
        if (![self isNumber:self.txtLatitude.text] || ![self isNumber:self.txtLongitude.text])
            return;
        
        CameraModel *camera = [CoreDataModel.sharedInstance insertItem:@"CameraModel"];
        
        float la = [self.txtLatitude.text floatValue];
        float lo = [self.txtLongitude.text floatValue];
        
        camera.latitude = la;
        camera.longitude = lo;
        
        camera.cameraName = self.txtCameraName.text;
        camera.brand = self.txtBrand.text;
        camera.modelNumber = self.txtModelNumber.text;
        camera.notes = self.txtNotes.text;
        camera.location = @"";
        camera.createdAt = [NSDate date];
        
        if ([CoreDataModel.sharedInstance saveData]) {
            [locationManager stopUpdatingLocation];
            [self.delegate cameraAdded:camera];
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }
}

#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocationCoordinate2D coordinateInputed;
    coordinateInputed = locations[0].coordinate;
    self.txtLatitude.text = [NSString stringWithFormat:@"%.3f", coordinateInputed.latitude];
    self.txtLongitude.text = [NSString stringWithFormat:@"%.3f", coordinateInputed.longitude];
    [locationManager stopUpdatingLocation];
}

@end
