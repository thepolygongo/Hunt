//
//  BestTimeCtrl.h
//  HuntSmart
//
//  Created by Wildlife Management Services on 5/8/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "BaseCtrl.h"

#import <Charts/Charts-Swift.h>
#import <MKDropdownMenu/MKDropdownMenu.h>

#import "CameraModel+CoreDataProperties.h"
#import "ImageModel+CoreDataProperties.h"
#import "TwoHoursFormatter.h"
#import "BestTimeCell.h"

@interface BestTimeCtrl : BaseCtrl  <UITableViewDelegate, UITableViewDataSource> {
    NSArray<NSString *> *mAnimalLabels;
    NSArray<NSString *> *mAnimalImages;
    NSMutableArray<NSMutableDictionary *> *mChartData;
}

@property (strong, nonatomic) CameraModel *mCamera;


@property (weak, nonatomic) IBOutlet UILabel *lblBestTimeDeer;
@property (weak, nonatomic) IBOutlet UILabel *lblBestTimeHog;
@property (nonatomic) int animalIndex;

@property (strong, nonatomic) NSMutableArray<NSNumber *> *bestTimes;

@end
