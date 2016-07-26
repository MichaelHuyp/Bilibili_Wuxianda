//
//  UIImage+YPExtension.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/1/21.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YPExtension)

/** 压缩 */
- (UIImage *)yp_scaleToSize:(CGSize)size;

/** 等比例压缩 */
- (UIImage *)yp_imageCompressForSize:(CGSize)size;

/**
 *  返回指定尺寸的图片
 */
- (UIImage *)yp_imageWithScaleSize:(CGSize)scaleSize;

/**
 *  返回拉伸后的图片,默认为从中点拉伸
 */
+ (UIImage *)yp_resizeImageWithName:(NSString *)imageName;

/**
 *  返回拉伸后的图片,指定拉伸位置
 */
+ (UIImage *)yp_resizeImageWithName:(NSString *)imageName edgeInsets:(UIEdgeInsets)edgeInset;

/**
 *  将方图片转换成圆图片
 */
+ (UIImage *)yp_circleImageWithOldImage:(UIImage *)oldImage borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

+ (UIImage *)yp_generateCenterImageWithBgColor:(UIColor *)bgImageColor bgImageSize:(CGSize)bgImageSize centerImage:(UIImage *)centerImage;


@end
