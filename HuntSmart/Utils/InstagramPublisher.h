//
//  InstagramPublisher.h
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/22/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Utils.h"

@interface InstagramPublisher : NSObject <UIDocumentInteractionControllerDelegate>

@property (nonatomic, retain) UIDocumentInteractionController *documentController;

- (void)postImage:(UIImage *)imgShare withText:(NSString *)text inView:(UIViewController *)vc failure:(failure)failure;

@end
