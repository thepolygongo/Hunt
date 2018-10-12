//
//  GMSViewController.m
//  HuntSmart
//
//  Created by ll on 2018/9/25.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "GMSViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import <CoreLocation/CoreLocation.h>

@interface GMSViewController () <GMSAutocompleteViewControllerDelegate, GMSMapViewDelegate>

    @property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation GMSViewController{
    GMSMapView *mapView;
    GMSCameraPosition *camera;
    GMSMarker *marker;
    CLLocation *currentLocation;
    BOOL locationUpdated;
//    CLLocationManager *locationManager;
}
    @synthesize delegate;
    
    
- (void)loadView {
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    camera = [GMSCameraPosition cameraWithLatitude:self.coordinate.latitude
                                                            longitude:self.coordinate.longitude
                                                                 zoom:6];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    mapView.settings.myLocationButton = true;
    self.view = mapView;
    mapView.delegate = self;
    
    // Creates a marker in the center of the map.
    marker = [[GMSMarker alloc] init];
    marker.position = self.coordinate;
    marker.title = @"Camera";
    marker.snippet = @"location";
    marker.map = mapView;
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    locationUpdated = false;
    if(self){
        _locationManager = [[CLLocationManager alloc] init];
        //locationManager.delegate = self;
        [_locationManager setDelegate:self];
        [_locationManager setDistanceFilter:kCLHeadingFilterNone];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
        [_locationManager startUpdatingLocation];
    }
    
    
    // Initialize
//    let items = ["Hybrid", "Normal", "Satellite"]
//    let customSC = UISegmentedControl(items: items)
//    customSC.selectedSegmentIndex = 0
//
//    // Set up Frame and SegmentedControl
//    let frame = UIScreen.main.bounds
//    customSC.frame = CGRect(x: frame.minX + 50 , y: frame.minY + 80, width: frame.width - 100, height: 40)
//
//    // Style the Segmented Control
//    customSC.layer.cornerRadius = 5.0  // Don't let background bleed
//    customSC.backgroundColor = UIColor.white
//    customSC.alpha = 0.8
//
//    // Add target action method
//    customSC.addTarget(self, action: #selector(MapViewController.changeColor(sender:)), for: .valueChanged)
//
//    // Add this custom Segmented Control to our view
//    self.view.addSubview(customSC)
    
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc]initWithItems: @[@"Normal", @"Satellite", @"Hybrid"]];
    
    [segmentControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    segmentControl.frame = CGRectMake(50, 80, 300, 40);
    [segmentControl addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [segmentControl setSelectedSegmentIndex:0];
    [segmentControl setBackgroundColor:UIColor.whiteColor];
    [segmentControl setAlpha:0.8];
    [self.view addSubview:segmentControl];
}
-(void)segmentedControlValueDidChange:(UISegmentedControl *)segment
    {
        switch (segment.selectedSegmentIndex) {
            case 0:{
                //action for the first button (Current)
                mapView.mapType = kGMSTypeNormal;
                break;}
            case 1:{
                mapView.mapType = kGMSTypeSatellite;
                //action for the first button (Current)
                break;}
            case 2:{
                mapView.mapType = kGMSTypeHybrid;
                //action for the first button (Current)
                break;}
        }
    }
    - (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate{
        marker.position = coordinate;//CLLocationCoordinate2DMake(-33.86, 151.20);
    }
    
    // Present the autocomplete view controller when the button is pressed.
- (IBAction)onSearchClicked:(id)sender {
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    [self presentViewController:acController animated:YES completion:nil];
}
    
- (IBAction)onDoneClicked:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate returnLocation:marker.position.latitude second:marker.position.longitude];
}

- (IBAction)onCancelClicked:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    // Do something with the selected place.
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
    
    mapView.camera = [GMSCameraPosition cameraWithTarget:place.coordinate zoom:14];
}
    
- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}
    
    // User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}
    
    // Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
    
- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
    
#pragma mark - CLLocationManagerDelegate
    
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
    {
        NSLog(@"didFailWithError: %@", error);
    }
    
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
    {
        if(locationUpdated){
            return;
        }
        else{
            locationUpdated = true;
        }
        NSLog(@"didUpdateToLocation: %@", newLocation);
//        mapView.camera = [GMSCameraPosition cameraWithTarget:newLocation.coordinate zoom:14];
//        marker.position = newLocation.coordinate;//CLLocationCoordinate2DMake(-33.86, 151.20);
        [_locationManager stopUpdatingHeading];
    }
@end
