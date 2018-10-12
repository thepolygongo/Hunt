//
//  InstagramPublisher.m
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/22/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "InstagramPublisher.h"

@implementation InstagramPublisher

- (void)postImage:(UIImage *)imgShare withText:(NSString *)text inView:(UIViewController *)vc failure:(failure)failure
{
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];

    if([[UIApplication sharedApplication] canOpenURL:instagramURL]) //check for App is install or not
    {
        UIImage *imageToUse = imgShare;
        NSString *documentDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *saveImagePath = [documentDirectory stringByAppendingPathComponent:@"Image.ig"];
        NSData *imageData = UIImagePNGRepresentation(imageToUse);
        [imageData writeToFile:saveImagePath atomically:YES];
        NSURL *imageURL = [NSURL fileURLWithPath:saveImagePath];

        self.documentController = [[UIDocumentInteractionController alloc] init];
        self.documentController = [UIDocumentInteractionController interactionControllerWithURL:imageURL];
        self.documentController.delegate = self;
        self.documentController.annotation = [NSDictionary dictionaryWithObject:text forKey:@"InstagramCaption"];
        self.documentController.UTI = @"com.instagram.photo";
        [self.documentController presentOpenInMenuFromRect:CGRectMake(1, 1, 1, 1) inView:vc.view animated:YES];
    }
    else {
        if (failure) {
            failure(@"Instagram not found");
        }
    }
}

- (UIDocumentInteractionController *)setupControllerWithURL:(NSURL *)fileURL usingDelegate:(id <UIDocumentInteractionControllerDelegate>)interactionDelegate {
    NSLog(@"file url %@",fileURL);
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    
    return interactionController;
}

@end
