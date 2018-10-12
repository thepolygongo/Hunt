//
//  ImageLabelsCtrl.m
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/19/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "ImageLabelsCtrl.h"

@interface ImageLabelsCtrl ()

@end

@implementation ImageLabelsCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isFirstLoad = true;
    
    self.mTableView.layoutMargins = UIEdgeInsetsZero;
    self.mTableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    self.mLabels = [NSMutableArray new];
    
    NSArray<NSString *> *labels = getResourcesFromPlist(@"resources", @"AnimalLabels");
    NSArray<NSString *> *images = getResourcesFromPlist(@"resources", @"LabelImages");
    NSArray<NSString *> *summaries = getResourcesFromPlist(@"resources", @"LabelSummaries");
    
    for (int i = 0; i < labels.count; i++) {
        AnimalLabel *animalLabel = [[AnimalLabel alloc] initWithName:labels[i] image:images[i] summary:summaries[i]];
        animalLabel.imageCount = [self getImageCountInLabel:animalLabel.labelName];
        [self.mLabels addObject:animalLabel];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (isFirstLoad) {
        isFirstLoad = false;
    }
    else {
        for (AnimalLabel *animalLabel in self.mLabels) {
            animalLabel.imageCount = [self getImageCountInLabel:animalLabel.labelName];
        }
        [self.mTableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Instance methods

- (NSUInteger)getImageCountInLabel:(NSString *)label {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"camera == %d AND label == %@ AND inImages == YES", self.mCamera.id, label];
    return [CoreDataModel.sharedInstance getCount:@"ImageModel" predicate:predicate];
}

#pragma mark - View click actions

#pragma mark - UITableView delegate and datasource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mLabels.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ImageLabelCell *cell = [self.mTableView dequeueReusableCellWithIdentifier:@"ImageLabelCell"];
    AnimalLabel *animalLabel = [self.mLabels objectAtIndex:indexPath.row];
    
    cell.imgLabel.image = [UIImage imageNamed:animalLabel.labelImage];
    cell.lblLabel.text = animalLabel.labelName.capitalizedString;
    cell.lblCount.text = [NSString stringWithFormat: @"%lld Images", animalLabel.imageCount];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.mTableView deselectRowAtIndexPath:indexPath animated:false];
    
    ViewImagesCtrl *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewImagesCtrl"];
    ctrl.mCamera = self.mCamera;
    ctrl.mLabel = [self.mLabels objectAtIndex:indexPath.row];
    [self showViewController:ctrl sender:nil];
}

@end
