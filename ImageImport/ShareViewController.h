//
//  ShareViewController.h
//  ImageImport
//
//  Created by Wildlife Management Services on 5/16/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import <Social/Social.h>
#include "Toast.h"
#import <Photos/Photos.h>

#import "Utils.h"
#import "Extensions.h"
#import "ImageModel+CoreDataProperties.h"
#import "ChooseCameraCtrl.h"

@interface ShareViewController : SLComposeServiceViewController <CameraChooseDelegate> {
    int lastImageID;
    BOOL isContentValid;
    BOOL isImageSaved;
    NSMutableArray *imageUrls;
    SLComposeSheetConfigurationItem *cameraItem;
}

@property (strong, nonatomic) CameraModel *camera;

@end
