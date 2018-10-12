//
//  ImageLabelsCtrl.h
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/19/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "BaseCtrl.h"
#import "ViewImagesCtrl.h"

#import "CameraModel+CoreDataProperties.h"
#import "ImageModel+CoreDataProperties.h"
#import "AnimalLabel.h"

#import "ImageLabelCell.h"

@interface ImageLabelsCtrl : BaseCtrl <UITableViewDelegate, UITableViewDataSource> {
    BOOL isFirstLoad;
}

@property (strong, nonatomic) CameraModel *mCamera;
@property (strong, nonatomic) NSMutableArray<AnimalLabel *> *mLabels;

@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end
