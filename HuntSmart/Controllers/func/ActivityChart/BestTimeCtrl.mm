//
//  BestTimeCtrl.mm
//  HuntSmart
//
//  Created by Wildlife Management Services on 5/8/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "BestTimeCtrl.h"

@implementation BestTimeCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // init variables
    
    self.animalIndex = 0;
    //mAnimalLabels = getResourcesFromPlist(@"resources", @"AnimalLabels");
    mAnimalLabels = getResourcesFromPlist(@"resources", @"BestTimeLabels");
    //mAnimalImages = @[@"hog_cross.png", @"raccoon_cross.png", @"deer_cross.png"];
    mAnimalImages = @[@"deerphotos2.png", @"blackbearphotos.png", @"hogphotos.png", @"turkeyphotos.png"];
    
    // init UI elements
    
    [self getData];
    if (![[NSUserDefaults standardUserDefaults]
          boolForKey:@"besttime_instruction"]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Instructions" message:@"The times displayed show the highest time windows of activity for each animal." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"besttime_instruction"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - instance methods

- (NSDate *)getFirstOrLastDate:(BOOL)isFirst {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"inCharts == YES AND camera == %d", self.mCamera.id];
    ImageModel *image = [CoreDataModel.sharedInstance getFirstOrLast:@"ImageModel" predicate:predicate isFirst:isFirst];
    
    if (image) {
        return image.createdAt;
    }
    return [NSDate date];
}

- (NSUInteger)getCountOfAnimal:(NSString *)label from:(NSInteger)fromHour toHour:(NSInteger)toHour {
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"inCharts == YES AND camera == %d AND label == %@", self.mCamera.id, label];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"hour >= %d AND hour < %d", fromHour, toHour];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate1, predicate2]];
    return [CoreDataModel.sharedInstance getCount:@"ImageModel" predicate:predicate];
}

- (void)getData {
    self.bestTimes = [NSMutableArray new];
    
    for (int animal = 0; animal < mAnimalLabels.count; animal++) {
        int bestTime = -1, bestCount = 0;
        
        for (NSInteger hour = 0; hour < 24; hour += 2) {
            NSUInteger count = [self getCountOfAnimal:mAnimalLabels[animal] from:hour toHour:hour+2];
            if (count > bestCount) {
                bestTime = hour;
                bestCount = count;
            }
        }
        
        [self.bestTimes addObject:[NSNumber numberWithInt:bestTime]];
    }
}

#pragma mark - UITableView delegate and datasource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mAnimalLabels.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    BestTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BestTimeCell"];
    [self renderTableViewCell:cell cellForRowAtIndexPath:indexPath];
    return cell;
}

- (void)renderTableViewCell:(BestTimeCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
    cell.imgAnimal.image = [UIImage imageNamed:mAnimalImages[indexPath.row]];
    cell.lblbesttimename.text =[NSString stringWithFormat:@"%@", mAnimalLabels[indexPath.row]];
    
    // set most active time string
    int fromHour = self.bestTimes[indexPath.row].intValue;
    if (fromHour < 0) {
        cell.lblBestTime.text = @"Not Present";
    }
    else {
        NSString *timeRange = [TwoHoursFormatter twoHoursString:fromHour];
        NSString *string = [NSString stringWithFormat:@"%@", timeRange];
        cell.lblBestTime.text = string;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:false];
}

@end
