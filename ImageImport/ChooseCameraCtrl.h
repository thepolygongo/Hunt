//
//  ChooseCameraCtrl.h
//  ImageImport
//
//  Created by Wildlife Management Services on 5/16/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "CameraCell.h"
#import "CoreDataModel.h"
#import "CameraModel+CoreDataProperties.h"

@protocol CameraChooseDelegate <NSObject>

- (void)cameraChoosed:(CameraModel *)camera;

@end


@interface ChooseCameraCtrl : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) id <CameraChooseDelegate> delegate;
@property (strong, nonatomic) NSMutableArray<CameraModel *> *mCameras;

@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end
