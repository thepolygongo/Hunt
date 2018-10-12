//
//  LargeViewCtrl.h
//  HuntSmart
//
//  Created by Wildlife Management Services on 4/30/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "BFRImageViewController.h"

#import "BaseCtrl.h"
#import "LargeViewCell.h"
#import "ImageModel+CoreDataProperties.h"

@interface LargeViewCtrl : BaseCtrl <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LargeViewCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic) int selectedImageIndex;
@property (strong, nonatomic) NSArray<ImageModel *> *mImages;
@property (strong, nonatomic) NSDictionary *mWeathers;

@end
