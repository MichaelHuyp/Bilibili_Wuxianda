//
//  YPRecommendContentLargeStyleLayout.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/13.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPRecommendContentLargeStyleLayout.h"

@interface YPRecommendContentLargeStyleLayout ()

/** 布局属性数组 */
@property (nonatomic, strong) NSMutableArray *attrsArray;

@end

@implementation YPRecommendContentLargeStyleLayout

#pragma mark - Lazy
- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

#pragma mark - Override
- (void)prepareLayout
{
    [super prepareLayout];
    
    [self.attrsArray removeAllObjects];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
    
    [self.attrsArray addObject:attrs];
    
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // 边距
    CGFloat margin = kAppPadding_8;
    // 宽度
    CGFloat width = self.collectionView.width - 2 * margin;
    // 高度
    CGFloat height = 120;
    
    // 坐标x值
    CGFloat x = margin;
    // 坐标y值
    CGFloat y = 0;
    
    attrs.frame = CGRectMake(x, y, width, height);
    
    return attrs;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}
@end
