//
//  CamerasCtrl.m
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/15/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "CamerasCtrl.h"

@interface CamerasCtrl ()

@end

@implementation CamerasCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mTableView.layoutMargins = UIEdgeInsetsZero;
    self.mTableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    self.lastCameraID = 0;
    self.mCameras = [CoreDataModel.sharedInstance getData:@"CameraModel" sortKey:@"createdAt" ascending:false];
    if (self.mCameras.count > 0) {
        self.lastCameraID = [self.mCameras objectAtIndex:0].id;
    }
    if (![[NSUserDefaults standardUserDefaults]
          boolForKey:@"camadd_instruction"]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Instructions" message:@"Press the + at the bottom of the screen to add a new camera. \n\nYou will then be asked to enable location services. Many features of WiseEye: Smart Cam rely on the location services. Please enable on the next screen." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"camadd_instruction"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}

#pragma mark - instance methods

- (void)deleteCamera:(NSIndexPath *)indexPath {
    CameraModel *camera = [self.mCameras objectAtIndex:indexPath.row];
    [self deleteAllImagesInCamera:camera.id];
    [self deleteAllWeatherDataInCamera:camera.id];
    [CoreDataModel.sharedInstance removeData:camera];
    [self.mCameras removeObject:camera];
    
    [self.mTableView beginUpdates];
    [self.mTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationRight];
    [self.mTableView endUpdates];
}

- (void)deleteAllImagesInCamera:(int16_t)cameraID {
    NSManagedObjectContext *moc = CoreDataModel.sharedInstance.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ImageModel" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    // filter records
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"camera == %d", cameraID];
    [request setPredicate:predicate];
    
    // delete request
    NSBatchDeleteRequest *deleteRquest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    // delete images
    NSPersistentStoreCoordinator *psc = CoreDataModel.sharedInstance.persistentStoreCoordinator;
    NSError *deleteError = nil;
    [psc executeRequest:deleteRquest withContext:moc error:&deleteError];
}

- (void)deleteAllWeatherDataInCamera:(int16_t)cameraID {
    NSManagedObjectContext *moc = CoreDataModel.sharedInstance.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WeatherModel" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    // filter records
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"camera == %d", cameraID];
    [request setPredicate:predicate];
    
    // delete request
    NSBatchDeleteRequest *deleteRquest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    // delete weathers
    NSPersistentStoreCoordinator *psc = CoreDataModel.sharedInstance.persistentStoreCoordinator;
    NSError *deleteError = nil;
    [psc executeRequest:deleteRquest withContext:moc error:&deleteError];
}

#pragma mark - camera add delegate

- (void)cameraAdded:(CameraModel *)camera {
    self.lastCameraID += 1;
    camera.id = self.lastCameraID;
    [CoreDataModel.sharedInstance saveData];
    
    [self.mCameras insertObject:camera atIndex:0];
    [self.mTableView beginUpdates];
    [self.mTableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationRight];
    [self.mTableView endUpdates];
}

#pragma mark - view click actions

- (IBAction)onClickBtnAdd:(id)sender {
    CameraAddCtrl *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"CameraAddCtrl"];
    ctrl.delegate = self;
    [self showViewController:ctrl sender:nil];
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
    cell.lblCameraBrand.text = camera.brand;
    cell.lblModelNumber.text = camera.modelNumber;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.mTableView deselectRowAtIndexPath:indexPath animated:false];
    
    HomeCtrl *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeCtrl"];
    ctrl.mCamera = [self.mCameras objectAtIndex:indexPath.row];
    [self showViewController:ctrl sender:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self deleteCamera:indexPath];
}

@end
