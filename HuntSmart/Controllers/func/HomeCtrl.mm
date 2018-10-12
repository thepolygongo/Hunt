//
//  HomeCtrl.m
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/15/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "HomeCtrl.h"

@interface HomeCtrl ()

@end

@implementation HomeCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (![[NSUserDefaults standardUserDefaults]
          boolForKey:@"main_instruction"]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Instructions" message:@"Now you can add photos to your camera by using the Import option. Once photos are imported and sorted you can view them in the View Images section. You also have access to Activity Graphs and Solunar information all from this page and all specific to this camera location. If you would like to add another camera, use the Back button at the top left to return to the camera list." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"main_instruction"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - camera change delegate

- (void)cameraChanged:(CameraModel *)camera {
    self.mCamera = camera;
}

#pragma mark - view click actions

- (IBAction)onClickBtnDownloadImages:(id)sender {
    DownloadImagesCtrl *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"DownloadImagesCtrl"];
    ctrl.mCamera = self.mCamera;
    [self showViewController:ctrl sender:nil];
}

- (IBAction)onClickBtnViewImages:(id)sender {
    ImageLabelsCtrl *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageLabelsCtrl"];
    ctrl.mCamera = self.mCamera;
    [self showViewController:ctrl sender:nil];
}

- (IBAction)onClickBtnActivityChart:(id)sender {
    ActivityChartCtrl *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityChartCtrl"];
    ctrl.mCamera = self.mCamera;
    [self showViewController:ctrl sender:nil];
}

- (IBAction)onClickBtnBestTime:(id)sender {
    BestTimeCtrl *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"BestTimeChartCtrl"];
    ctrl.mCamera = self.mCamera;
    [self showViewController:ctrl sender:nil];
}

- (IBAction)onClickBtnCameraSettings:(id)sender {
    CameraSettingsCtrl *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"CameraSettingsCtrl"];
    ctrl.mCamera = self.mCamera;
    ctrl.delegate = self;
    [self showViewController:ctrl sender:nil];
}
- (IBAction)onClickBtnSolunar:(id)sender {
    solunar_predict *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"slpredictor"];
    ctrl.mCamera = self.mCamera;
    [self showViewController:ctrl sender:nil];
}

@end
