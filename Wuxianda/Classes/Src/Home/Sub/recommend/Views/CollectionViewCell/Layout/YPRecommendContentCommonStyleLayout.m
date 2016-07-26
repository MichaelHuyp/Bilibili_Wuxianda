//
//  YPRecommendContentCommonStyleLayout.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/13.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPRecommendContentCommonStyleLayout.h"

@interface YPRecommendContentCommonStyleLayout ()

/** 布局属性数组 */
@property (nonatomic, strong) NSMutableArray *attrsArray;

@end

@implementation YPRecommendContentCommonStyleLayout

#pragma mark - Lazy
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
    
    [self.attrsArray removeAllObjects];
    
    for (int i = 0; i < self.itemCount; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [self.attrsArray addObject:attrs];
    }
    
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 边距
    CGFloat margin = kAppPadding_8;
    // 宽度
    CGFloat width = (self.collectionView.width - 3 * margin) * 0.5;
    // 高度
    CGFloat height = _itemHeight;
    
    // 创建布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // 行
    NSInteger row = indexPath.item / 2;
    // 列
    NSInteger col = indexPath.item % 2;
    
    // 坐标x值
    CGFloat x = col * width + (col + 1) * margin;
    // 坐标y值
    CGFloat y = row * (height + margin);
    
    attrs.frame = CGRectMake(x, y, width, height);
    
    return attrs;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}


@end






































