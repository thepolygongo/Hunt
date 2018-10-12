//
//  ActivityChartCtrl.m
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/15/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "ActivityChartCtrl.h"

@interface ActivityChartCtrl ()

@end

@implementation ActivityChartCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // init variables
    
    dateLimit = @[[self getFirstOrLastDate:true], [self getFirstOrLastDate:false]];
    
    self.animalIndex = 0;
    mAnimalLabels = getResourcesFromPlist(@"resources", @"AnimalLabels");
    
    // init DatePicker
    
    datePicker = [UIDatePicker new];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.txtDate.inputView = datePicker;
    
    [datePicker setMinimumDate:dateLimit[0]];
    [datePicker setMaximumDate:dateLimit[1]];
    [datePicker setDate:dateLimit[0]];
    
    // Set up dropdown menu loaded from storyboard
    // Note that `dataSource` and `delegate` outlets are connected in storyboard
    
    UIColor *selectedBackgroundColor = [UIColor colorWithRed:0.91 green:0.92 blue:0.94 alpha:1.0];
    self.animalMenu.selectedComponentBackgroundColor = selectedBackgroundColor;
    self.animalMenu.dropdownBackgroundColor = selectedBackgroundColor;
    
    self.animalMenu.dropdownShowsTopRowSeparator = NO;
    self.animalMenu.dropdownShowsBottomRowSeparator = NO;
    self.animalMenu.dropdownShowsBorder = YES;
    
    self.animalMenu.backgroundDimmingOpacity = 0.05;
    
    // init UI elements
    
    self.txtDate.text = getDateStringFromDate(datePicker.date);
    
    [self setupBarChart];
    [self reloadBarChart];
    if (![[NSUserDefaults standardUserDefaults]
          boolForKey:@"activity_instruction"]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Thank You" message:@"Select the date and species at the top of the screen to get the activity for that animal on that date at the camera location. If you tap the date field a date selector will appear which will only let you pick from dates where you have images saved." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"activity_instruction"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.animalMenu closeAllComponentsAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - instance methods

- (void)setupBarChart {
    self.mChartView.delegate = self;
    
    self.mChartView.chartDescription.enabled = NO;
    
    self.mChartView.dragEnabled = NO;
    [self.mChartView setScaleEnabled:NO];
    self.mChartView.pinchZoomEnabled = NO;
    
    self.mChartView.drawGridBackgroundEnabled = YES;
    self.mChartView.drawBarShadowEnabled = NO;
    self.mChartView.drawValueAboveBarEnabled = YES;
    
    ChartXAxis *xAxis = self.mChartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:12.f];
    xAxis.labelCount = 12;
    xAxis.granularity = 2.0;
    xAxis.axisMinimum = - 1.0;
    xAxis.axisMaximum = 23;
    xAxis.drawAxisLineEnabled = YES;
    xAxis.drawGridLinesEnabled = NO;
    xAxis.drawLabelsEnabled = YES;
    xAxis.valueFormatter = [TwoHoursFormatter new];
    
    ChartYAxis *leftAxis = self.mChartView.leftAxis;
    leftAxis.labelFont = [UIFont systemFontOfSize:12.f];
    leftAxis.drawAxisLineEnabled = YES;
    leftAxis.drawLabelsEnabled = NO;
    leftAxis.drawGridLinesEnabled = NO;
    leftAxis.granularity = 1.0;
    leftAxis.axisMinimum = 0; // this replaces startAtZero = YES
    
    ChartYAxis *rightAxis = self.mChartView.rightAxis;
    rightAxis.enabled = YES;
    rightAxis.labelFont = [UIFont systemFontOfSize:12.f];
    rightAxis.drawAxisLineEnabled = YES;
    rightAxis.drawLabelsEnabled = NO;
    rightAxis.drawGridLinesEnabled = NO;
    rightAxis.granularity = 1.0;
    rightAxis.axisMinimum = 0; // this replaces startAtZero = YES
    
    ChartLegend *legend = self.mChartView.legend;
    legend.horizontalAlignment = ChartLegendHorizontalAlignmentLeft;
    legend.verticalAlignment = ChartLegendVerticalAlignmentBottom;
    legend.orientation = ChartLegendOrientationHorizontal;
    legend.drawInside = YES;
    legend.form = ChartLegendFormSquare;
    legend.formSize = 8.0;
    legend.font = [UIFont fontWithName:@"Helvetica" size:12.f];
    legend.xEntrySpace = 2.0;
    
    self.mChartView.fitBars = YES;
}

- (NSDate *)getFirstOrLastDate:(BOOL)isFirst {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"inCharts == YES AND camera == %d", self.mCamera.id];
    ImageModel *image = [CoreDataModel.sharedInstance getFirstOrLast:@"ImageModel" predicate:predicate isFirst:isFirst];
    
    if (image) {
        return image.createdAt;
    }
    return [NSDate date];
}

- (NSUInteger)getCountOfAnimal:(NSString *)label dateRange:(NSArray<NSDate *> *)dateRange {
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"inCharts == YES AND camera == %d AND label == %@", self.mCamera.id, label];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"createdAt >= %@ AND createdAt < %@", dateRange[0], dateRange[1]];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate1, predicate2]];
    return [CoreDataModel.sharedInstance getCount:@"ImageModel" predicate:predicate];
}

- (void)onDatePickerValueChanged:(UIDatePicker *)datePicker {
    self.txtDate.text = getDateStringFromDate(datePicker.date);
}

- (void)updateBarChartData {
    double barWidth = 1.75;
    double spaceForXAxis = 2.0;
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    NSDate *fromDate = getDateFromDateString(self.txtDate.text);
    NSDate *endDate = [fromDate dateByAddingTimeInterval:(1*24*60*60-1)];
    
    while (true) {
        NSDate *toDate = [fromDate dateByAddingTimeInterval:(2*60*60)];
        
        NSUInteger count = [self getCountOfAnimal:mAnimalLabels[self.animalIndex] dateRange:@[fromDate, toDate]];
        int xValue = 22 - spaceForXAxis*yVals.count;
        BarChartDataEntry *entry = [[BarChartDataEntry alloc] initWithX:xValue y:count];
        [yVals addObject:entry];
        
        fromDate = toDate;
        if ([fromDate compare:endDate] != NSOrderedAscending) {
            break;
        }
    }
    
    BarChartDataSet *dataSet = nil;
    if (self.mChartView.data.dataSetCount > 0)
    {
        dataSet = (BarChartDataSet *)self.mChartView.data.dataSets[0];
        dataSet.values = yVals;
        [self.mChartView.data notifyDataChanged];
        [self.mChartView notifyDataSetChanged];
    }
    else
    {
        dataSet = [[BarChartDataSet alloc] initWithValues:yVals label:nil];
        dataSet.drawIconsEnabled = YES;
        dataSet.valueFormatter = [BarValueFormatter new];
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:dataSet];
        
        BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
        [data setValueFont:[UIFont fontWithName:@"Helvetica-Bold" size:18.f]];
        data.barWidth = barWidth;
        
        self.mChartView.data = data;
    }
}

- (void)reloadBarChart {
    [self.view endEditing:true];
    [self showProgress:@"Reloading..."];
    
    [self runAsync:^{
        [self updateBarChartData];
        [self hideProgress];
    } afterDelay:0.1];
}

#pragma mark - MKDropdownMenuDataSource

- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu {
    return 1;
}

- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component {
    return 4;
}

#pragma mark - MKDropdownMenuDelegate

- (CGFloat)dropdownMenu:(MKDropdownMenu *)dropdownMenu rowHeightForComponent:(NSInteger)component {
    return 30; // use default row height
}

- (CGFloat)dropdownMenu:(MKDropdownMenu *)dropdownMenu widthForComponent:(NSInteger)component {
    return 0; // use automatic width
}

- (BOOL)dropdownMenu:(MKDropdownMenu *)dropdownMenu shouldUseFullRowWidthForComponent:(NSInteger)component {
    return NO;
}

- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForComponent:(NSInteger)component {
    return [[NSAttributedString alloc] initWithString:mAnimalLabels[self.animalIndex].capitalizedString
                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightLight],
                                                        NSForegroundColorAttributeName: self.animalMenu.tintColor}];
}

- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForSelectedComponent:(NSInteger)component {
    return [[NSAttributedString alloc] initWithString:mAnimalLabels[self.animalIndex].capitalizedString
                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightRegular],
                                                        NSForegroundColorAttributeName: self.animalMenu.tintColor}];
}

- (UIView *)dropdownMenu:(MKDropdownMenu *)dropdownMenu viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    MenuRowView *menuView = (MenuRowView *)view;
    
    if (menuView == nil || ![menuView isKindOfClass:[MenuRowView class]]) {
        menuView = [MenuRowView new];
        menuView.backgroundColor = [UIColor clearColor];
    }
    [menuView setText:mAnimalLabels[row].capitalizedString];
    
    return menuView;
}

- (UIColor *)dropdownMenu:(MKDropdownMenu *)dropdownMenu backgroundColorForRow:(NSInteger)row forComponent:(NSInteger)component {
    return nil; // use default color
}

- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.animalIndex = (int)row;
    [dropdownMenu reloadAllComponents];
    
    [self reloadBarChart];
    
    delay(0.15, ^{
        [dropdownMenu closeAllComponentsAnimated:YES];
    });
}

#pragma mark - view click actions

- (IBAction)onClickBtnDone:(id)sender {
    [self reloadBarChart];
}

- (IBAction)onClickPreviousDate:(id)sender {
    datePicker.date = [datePicker.date dateByAddingTimeInterval:(-1*24*60*60)];
    self.txtDate.text = getDateStringFromDate(datePicker.date);
    
    [self reloadBarChart];
}

- (IBAction)onClickNextDate:(id)sender {
    datePicker.date = [datePicker.date dateByAddingTimeInterval:(1*24*60*60)];
    self.txtDate.text = getDateStringFromDate(datePicker.date);
    
    [self reloadBarChart];
}

@end
