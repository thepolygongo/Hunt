//
//  HorizontalCenteringFlowLayout.m
//  HuntSmart
//
//  Created by Wildlife Management Services on 5/14/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "HorizontalCenteringFlowLayout.h"

@implementation HorizontalCenteringFlowLayout

- (id)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    NSArray *layoutAttributesArray = [self layoutAttributesForElementsInRect:self.collectionView.bounds];
    UICollectionViewLayoutAttributes *candidate = layoutAttributesArray.firstObject;
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in layoutAttributesArray) {
        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            if ((velocity.x > 0 && layoutAttributes.center.x > candidate.center.x) ||
                (velocity.x <= 0 && layoutAttributes.center.x < candidate.center.x)) {
                candidate = layoutAttributes;
            }
        }
    }
    
    return CGPointMake(candidate.center.x - self.collectionView.bounds.size.width / 2, proposedContentOffset.y);
}

@end
