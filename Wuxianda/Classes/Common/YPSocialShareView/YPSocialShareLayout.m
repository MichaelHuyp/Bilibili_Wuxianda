//
//  YPSocialShareLayout.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/17.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPSocialShareLayout.h"

@interface YPSocialShareLayout ()

/** 所有的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;

@end

@implementation YPSocialShareLayout

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (int i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        CGFloat height = self.collectionView.height * 0.5;
        CGFloat width = height + 24;
        CGFloat margin = (self.collectionView.width - 3 * width) * 0.5;
        
        // 行
        int row = i / 3;
        // 列
        int col = i % 3;
        
        attrs.frame = CGRectMake(col * (margin + width), row * height, width, height);
        
        [self.attrsArray addObject:attrs];
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    return self.attrsArray;
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(0, self.collectionView.size.height);
}


@end



























