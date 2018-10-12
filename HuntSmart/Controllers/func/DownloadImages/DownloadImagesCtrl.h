//
//  DownloadImagesCtrl.h
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/15/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//


#import "DLFPhotosPickerViewController.h"
#import "predict_image.h"

#import "BaseCtrl.h"

#import "CameraModel+CoreDataProperties.h"
#import "ImageModel+CoreDataProperties.h"
#import "NetworkUtils.h"
#import "Weather.h"

#import "LoadedImageCell.h"

@interface DownloadImagesCtrl : BaseCtrl <DLFPhotosPickerViewControllerDelegate, UITableViewDelegate, UITableViewDataSource> {
    predict_image *mPredictor;
}

@property (strong, nonatomic) CameraModel *mCamera;
@property (strong, nonatomic) NSMutableArray<ImageModel *> *mImages;

@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property (weak, nonatomic) IBOutlet UIButton *btnAction;

@end
