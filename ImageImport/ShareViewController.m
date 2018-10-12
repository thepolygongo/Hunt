//
//  ShareViewController.m
//  ImageImport
//
//  Created by Wildlife Management Services on 5/16/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save Images" style:UIBarButtonItemStyleDone target:self action:@selector(onClickBtnDone)];
    self.navigationController.navigationBar.topItem.rightBarButtonItem = doneButtonItem;
    
    isContentValid = true;
    isImageSaved = false;
    imageUrls = [NSMutableArray new];
    lastImageID = [SettingUtils lastImageID];
    
    [self getAttachments];
}

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return true;
}

- (void)didSelectPost {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    __block ShareViewController *blockSelf = self;
    
    cameraItem = [SLComposeSheetConfigurationItem new];
    cameraItem.title = @"Camera";
    cameraItem.value = @"Choose";
    cameraItem.tapHandler = ^{
        ChooseCameraCtrl *ctrl = [blockSelf.storyboard instantiateViewControllerWithIdentifier:@"ChooseCameraCtrl"];
        ctrl.delegate = blockSelf;
        [blockSelf showViewController:ctrl sender:nil];
    };
    
    return @[cameraItem];
}

#pragma mark - instance methods

- (void)getAttachments {
    [imageUrls removeAllObjects];
    
    for (NSItemProvider* itemProvider in ((NSExtensionItem*)self.extensionContext.inputItems[0]).attachments) {
        if([itemProvider hasItemConformingToTypeIdentifier:@"public.image"]) {
            [itemProvider loadItemForTypeIdentifier:@"public.image" options:nil completionHandler:
             ^(id<NSSecureCoding> item, NSError *error)
             {
                 if([(NSObject*)item isKindOfClass:[NSURL class]]) {
                     [self->imageUrls addObject:item];
                 }
             }];
        }
        else {
            isContentValid = false;
            return;
        }
    }
}

- (void)saveImages:(block)completion {
    for (NSURL *imageURL in imageUrls) {
        lastImageID += 1;
        
        ImageModel *image = [CoreDataModel.sharedInstance insertItem:@"ImageModel"];
        image.id = lastImageID;
        image.hasWeather = false;
        image.camera = self.camera.id;
        image.path = imageURL.path;
        image.label = @"unlabeled";
        image.data = [NSData dataWithContentsOfURL:imageURL];
        image.inImages = true;
        image.inCharts = true;

        image.createdAt = [self creationDateForFilePath:imageURL.path];
        image.hour = image.createdAt.hour;
        
        [CoreDataModel.sharedInstance saveData];
    }
    
    isImageSaved = true;
    [SettingUtils saveLastImageID:lastImageID];
    
    completion();
}

#pragma mark - utils

- (NSDate *)creationDateForFilePath:(NSString *)path {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSDictionary* attrs = [fileManager attributesOfItemAtPath:path error:nil];
    NSDate *creationDate;
    
    if (attrs != nil) {
        creationDate = (NSDate*)[attrs objectForKey: NSFileCreationDate];
        NSLog(@"Date Created: %@", [creationDate description]);
    }
    else {
        creationDate = [NSDate date];
        NSLog(@"Not found");
    }
    
    return creationDate;
}

#pragma mark - button actions

- (void)onClickBtnDone {
    if (self.camera == nil) {
        [self.view makeToast:@"Please choose camera before saving images."];
        return;
    }
    if (!isContentValid) {
        [self.view makeToast:@"Please select images only."];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self saveImages:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToast:@"Successfully saved."];
                
                delay(1, ^{
                    [self didSelectPost];
                });
            });
        }];
    });
}

- (void)cameraChoosed:(CameraModel *)camera {
    self.camera = camera;
    cameraItem.value = camera.cameraName;
}

@end
