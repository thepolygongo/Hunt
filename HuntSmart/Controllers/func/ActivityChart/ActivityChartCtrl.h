//
//  ActivityChartCtrl.h
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/15/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "BaseCtrl.h"

#import <Charts/Charts-Swift.h>
#import <MKDropdownMenu/MKDropdownMenu.h>

#import "CameraModel+CoreDataProperties.h"
#import "ImageModel+CoreDataProperties.h"
#import "TwoHoursFormatter.h"
#import "BarValueFormatter.h"
#import "MenuRowView.h"

@interface ActivityChartCtrl : BaseCtrl <ChartViewDelegate, MKDropdownMenuDataSource, MKDropdownMenuDelegate> {
    NSArray<NSDate *> *dateLimit;
    UIDatePicker *datePicker;
    
    NSArray<NSString *> *mAnimalLabels;
    NSMutableArray<NSMutableDictionary *> *mChartData;
}

@property (strong, nonatomic) CameraModel *mCamera;

@property (weak, nonatomic) IBOutlet UITextField *txtDate;

@property (weak, nonatomic) IBOutlet HorizontalBarChartView *mChartView;

@property (weak, nonatomic) IBOutlet MKDropdownMenu *animalMenu;
@property (nonatomic) int animalIndex;

@end
