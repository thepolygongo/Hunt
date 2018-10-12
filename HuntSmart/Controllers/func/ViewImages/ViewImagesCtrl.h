//
//  ViewImagesCtrl.h
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/15/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <TwitterKit/TWTRKit.h>
#import <MessageUI/MessageUI.h>

#import "BaseCtrl.h"
#import "LargeViewCtrl.h"

#import "InstagramPublisher.h"
#import "NetworkUtils.h"

#import "CameraModel+CoreDataProperties.h"
#import "ImageModel+CoreDataProperties.h"

#import "AnimalLabel.h"
#import "ViewImageCell.h"

@interface ViewImagesCtrl : BaseCtrl <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) CameraModel *mCamera;
@property (strong, nonatomic) AnimalLabel *mLabel;
@property (strong, nonatomic) NSMutableArray<ImageModel *> *mImages;
@property (strong, nonatomic) NSMutableDictionary *mWeathers;
@property (strong, nonatomic) NSArray<NSString *> *mLabels;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end
