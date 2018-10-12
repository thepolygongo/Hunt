//
//  LargeViewCtrl.mm
//  HuntSmart
//
//  Created by Wildlife Management Services on 4/30/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "LargeViewCtrl.h"

@interface LargeViewCtrl () {
    BOOL onlyOnce;
    float cellWidth;
}

@end

@implementation LargeViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    onlyOnce = false;
    cellWidth = UIScreen.mainScreen.bounds.size.width;
    self.pageControl.numberOfPages = self.mImages.count;
    
    [self.collectionView registerNib:[UINib nibWithNibName:LargeViewCell.classIdentifier bundle:nil] forCellWithReuseIdentifier:LargeViewCell.classIdentifier];
    self.collectionView.layer.masksToBounds = false;
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pageValueChanged:(id)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.pageControl.currentPage inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
}

#pragma mark - UICollectionView delegate and datasource

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LargeViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:LargeViewCell.classIdentifier forIndexPath:indexPath];
    
    ImageModel *image = self.mImages[indexPath.item];
    WeatherModel *weather = [self.mWeathers valueForKey:@(indexPath.item).stringValue];
    
    cell.imageView.image = [UIImage imageWithData:image.data];
    
    cell.lblTemperature.text = weather.temperatureString;
    cell.lblHumidity.text = weather.humidityString;
    cell.lblPressure.text = weather.pressureString;
    cell.iconMoonPhase.image = [UIImage imageNamed:weather.moonPhaseIcon];
    cell.lblWindSpeed.text = weather.windSpeedString;
    cell.lblWindDirection.text = weather.windDirectionString;
    cell.lblSunrise.text = weather.sunriseString;
    cell.lblSunset.text = weather.sunsetString;
    cell.lblMoonrise.text = weather.moonrise;
    cell.lblMoonover.text = weather.moonover;
    cell.lblMoonset.text = weather.moonset;
    
    cell.delegate = self;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(cellWidth, collectionView.frame.size.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    float sideInset = (collectionView.frame.size.width - cellWidth) / 2;
    return UIEdgeInsetsMake(0, sideInset, 0, sideInset);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:UICollectionView.class]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[self.view convertPoint:self.view.center toView:self.collectionView]];
        self.pageControl.currentPage = indexPath.item;
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!onlyOnce) {
        // scroll to selected index only once
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.selectedImageIndex inSection:0];
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
        
        onlyOnce = true;
    }
}

#pragma mark - LargeViewCell delegate

- (void)onClickLargeViewCellClose:(LargeViewCell *)cell {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)onClickLargeViewCellImage:(LargeViewCell *)cell {
    BFRImageViewController *imageVC = [[BFRImageViewController alloc] initWithImageSource:@[cell.imageView.image]];
    [self showViewController:imageVC sender:nil];
}

@end
