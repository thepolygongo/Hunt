//
//  HomeCtrl.h
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/15/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "BaseCtrl.h"
#import "DownloadImagesCtrl.h"
#import "ImageLabelsCtrl.h"
#import "ActivityChartCtrl.h"
#import "BestTimeCtrl.h"
#import "CameraSettingsCtrl.h"
#import "CameraModel+CoreDataProperties.h"
#import "solunar_predict.h"

@interface HomeCtrl : BaseCtrl <CameraChangeDelegate>

@property (strong, nonatomic) CameraModel *mCamera;

@end
