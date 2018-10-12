//
//  CamerasCtrl.h
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/15/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "BaseCtrl.h"
#import "CameraAddCtrl.h"
#import "HomeCtrl.h"
#import "CameraCell.h"

@interface CamerasCtrl : BaseCtrl <UITableViewDelegate, UITableViewDataSource, CameraAddDelegate>

@property (nonatomic) int lastCameraID;
@property (strong, nonatomic) NSMutableArray<CameraModel *> *mCameras;

@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end
