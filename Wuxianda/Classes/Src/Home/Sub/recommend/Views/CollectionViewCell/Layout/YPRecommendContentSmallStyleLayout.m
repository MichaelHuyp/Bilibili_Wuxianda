//
//  YPRecommendContentSmallStyleLayout.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/13.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPRecommendContentSmallStyleLayout.h"

@implementation YPRecommendContentSmallStyleLayout

- (void)prepareLayout
{
    [super prepareLayout];
 
    self.itemSize = CGSizeMake(140, self.collectionView.height);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumInteritemSpacing = 8;
    self.sectionInset = UIEdgeInsetsMake(0, 8, 0, 8);
}

@end
