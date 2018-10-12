//
//  GMSViewController.h
//  HuntSmart
//
//  Created by ll on 2018/9/25.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN


@protocol GMSViewControllerDelegate <NSObject>
@optional
    -(void) returnLocation: (double) latitute second: (double) longitute;
@end

@interface GMSViewController : UIViewController
@property (nonatomic, weak) id <GMSViewControllerDelegate> delegate;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@end

NS_ASSUME_NONNULL_END
