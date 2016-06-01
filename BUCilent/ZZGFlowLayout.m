//
//  ZZGFlowLayout.m
//  ZZGViewPager
//
//  Created by dito on 16/4/18.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "ZZGFlowLayout.h"

@implementation ZZGFlowLayout {
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - Override Methods
- (void)prepareLayout {
    [super prepareLayout];
    self.itemSize = CGSizeMake(self.collectionView.bounds.size.width , self.collectionView.bounds.size.height);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
}

- (CGSize)collectionViewContentSize {
    return [super collectionViewContentSize];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    //todo
    
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    NSArray *cellIndices = self.collectionView.indexPathsForVisibleItems;
    //todo
    
    return attributes;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    NSUInteger index = roundf(proposedContentOffset.x / self.collectionView.bounds.size.width);
    return CGPointMake(index * self.collectionView.bounds.size.width, proposedContentOffset.y);
}


#pragma mark - private methods




@end





















































