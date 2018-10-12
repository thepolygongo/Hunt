//
//  ChooseCameraCtrl.m
//  ImageImport
//
//  Created by Wildlife Management Services on 5/16/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "ChooseCameraCtrl.h"

@implementation ChooseCameraCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mTableView.layoutMargins = UIEdgeInsetsZero;
    self.mTableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    self.mCameras = [CoreDataModel.sharedInstance getData:@"CameraModel" sortKey:@"createdAt" ascending:false];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - view click actions

- (IBAction)onClickBtnBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - UITableView delegate and datasource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.mCameras)
        return 0;
    return self.mCameras.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CameraCell *cell = [self.mTableView dequeueReusableCellWithIdentifier:@"CameraCell"];
    
    CameraModel *camera = [self.mCameras objectAtIndex:indexPath.row];
    cell.lblCameraName.text = camera.cameraName;
    cell.lblModelNumber.text = camera.modelNumber;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.mTableView deselectRowAtIndexPath:indexPath animated:false];
    
    if (self.delegate) {
        [self.delegate cameraChoosed:self.mCameras[indexPath.row]];
    }
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
