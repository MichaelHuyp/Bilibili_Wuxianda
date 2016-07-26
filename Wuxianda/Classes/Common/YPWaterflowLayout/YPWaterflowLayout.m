//
//  YPWaterflowLayout.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/8.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPWaterflowLayout.h"

/** 默认的列数 */
static NSUInteger const YPDefaultColumnCount = 3;

/** 每一列之间的间距 */
static CGFloat const YPDefaultColumnMargin = 10;

/** 每一行之间的间距 */
static CGFloat const YPDefaultRowMargin = 10;

/** 边缘间距 */
static UIEdgeInsets const YPDefaultEdgeInsets = {10,10,10,10};

@interface YPWaterflowLayout ()

/** 存放所有cell的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;

/** 存放所有列的当前高度 */
@property (nonatomic, strong) NSMutableArray *columnHeights;

/** 内容的高度 */
@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation YPWaterflowLayout

#pragma mark - data Handle
- (CGFloat)rowMargin
{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
        return [self.delegate rowMarginInWaterflowLayout:self];
    } else {
        return YPDefaultRowMargin;
    }
}

- (CGFloat)columnMargin
{
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterflowLayout:)]) {
        return [self.delegate columnMarginInWaterflowLayout:self];
    } else {
        return YPDefaultColumnMargin;
    }
}

- (NSUInteger)columnCount
{
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterflowLayout:)]) {
        return [self.delegate columnCountInWaterflowLayout:self];
    } else {
        return YPDefaultColumnCount;
    }
}

- (UIEdgeInsets)edgeInsets
{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterflowLayout:)]) {
        return [self.delegate edgeInsetsInWaterflowLayout:self];
    } else {
        return YPDefaultEdgeInsets;
    }
}

#pragma mark - Lazy

- (NSMutableArray *)columnHeights
{
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

/**
 *  初始化
 */
- (void)prepareLayout
{
    [super prepareLayout];
    
    self.contentHeight = 0;
    
    // 清除以前计算的所有高度
    [self.columnHeights removeAllObjects];
    
    for (NSUInteger i = 0; i < [self columnCount]; i++) {
        [self.columnHeights addObject:@([self edgeInsets].top)];
    }
    
    // 清除之前所有的布局属性
    [self.attrsArray removeAllObjects];
    

    // 开始创建每一个cell对应的布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger i = 0; i < count; i++) {
        
        // 创建位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        

        // 获取indexPath位置cell对应的布局属性
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [self.attrsArray addObject:attrs];
    }
}

/**
 *  决定cell的排布
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}

/**
 *  返回indexPath位置cell对应的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 创建布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // 设置布局属性frame
    
    // collectionView的宽度
    CGFloat collectionViewW = self.collectionView.width;
    
    
    CGFloat w = (collectionViewW - [self edgeInsets].left - [self edgeInsets].right - ([self columnCount] - 1) * [self columnMargin]) / [self columnCount];
    CGFloat h = [self.delegate waterflowLayout:self heightForItemAtIndex:indexPath.item itemWidth:w];
    
    
#if 0
    // 找出高度最短的那一列
    __block NSUInteger destColumn = 0;
    __block CGFloat minColumnHeight = MAXFLOAT;
    [self.columnHeights enumerateObjectsUsingBlock:^(NSNumber *columnHeightNumber, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat columnHeight = columnHeightNumber.doubleValue;
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = idx;
        }
    }];
#endif
    
    // 找出高度最短的那一列
    NSUInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    
    for (NSUInteger i = 1; i < [self columnCount]; i++) {
        // 取出第i列的高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    
    CGFloat x = [self edgeInsets].left + destColumn * (w + [self columnMargin]);
    CGFloat y = minColumnHeight;
    
    if (y != [self edgeInsets].top) {
        y += [self rowMargin];
    }
    
    attrs.frame = CGRectMake(x, y, w, h);
    
    // 更新最短那列的高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    
    // 记录内容的高度
    CGFloat columnHeight = [self.columnHeights[destColumn] doubleValue];
    if (self.contentHeight < columnHeight) {
        self.contentHeight = columnHeight;
    }
    
    return attrs;
}



- (CGSize)collectionViewContentSize
{
    return CGSizeMake(0, self.contentHeight + [self edgeInsets].bottom);
}

@end








































