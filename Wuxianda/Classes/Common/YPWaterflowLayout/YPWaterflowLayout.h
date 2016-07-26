//
//  YPWaterflowLayout.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/8.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YPWaterflowLayout;

@protocol YPWaterflowLayoutDelegate <NSObject>

@required
- (CGFloat)waterflowLayout:(YPWaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
- (NSUInteger)columnCountInWaterflowLayout:(YPWaterflowLayout *)waterflowLayout;
- (CGFloat)columnMarginInWaterflowLayout:(YPWaterflowLayout *)waterflowLayout;
- (CGFloat)rowMarginInWaterflowLayout:(YPWaterflowLayout *)waterflowLayout;
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(YPWaterflowLayout *)waterflowLayout;

@end

@interface YPWaterflowLayout : UICollectionViewLayout
@property (nonatomic, weak) id<YPWaterflowLayoutDelegate> delegate;
@end
