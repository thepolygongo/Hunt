//
//  LargeViewCell.h
//  HuntSmart
//
//  Created by Wildlife Management Services on 5/9/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LargeViewCell;

@protocol LargeViewCellDelegate <NSObject>

- (void)onClickLargeViewCellClose:(LargeViewCell *)cell;
- (void)onClickLargeViewCellImage:(LargeViewCell *)cell;

@end

@interface LargeViewCell : UICollectionViewCell

@property (weak, nonatomic) id <LargeViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *lblTemperature;
@property (weak, nonatomic) IBOutlet UILabel *lblHumidity;
@property (weak, nonatomic) IBOutlet UILabel *lblPressure;
@property (weak, nonatomic) IBOutlet UIImageView *iconMoonPhase;
@property (weak, nonatomic) IBOutlet UILabel *lblWindSpeed;
@property (weak, nonatomic) IBOutlet UILabel *lblWindDirection;
@property (weak, nonatomic) IBOutlet UILabel *lblSunrise;
@property (weak, nonatomic) IBOutlet UILabel *lblSunset;
@property (weak, nonatomic) IBOutlet UILabel *lblMoonrise;
@property (weak, nonatomic) IBOutlet UILabel *lblMoonover;
@property (weak, nonatomic) IBOutlet UILabel *lblMoonset;

@end
