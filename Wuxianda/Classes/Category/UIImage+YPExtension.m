//
//  UIImage+YPExtension.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/1/21.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "UIImage+YPExtension.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation UIImage (YPExtension)

- (UIImage *)yp_scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

- (UIImage *)yp_imageCompressForSize:(CGSize)size
{
    UIImage *newImage = nil;
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [self drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

/**
 *  返回指定尺寸的图片
 */
- (UIImage *)yp_imageWithScaleSize:(CGSize)scaleSize {
    
    UIGraphicsBeginImageContext(scaleSize);
    
    // 指定图片尺寸
    [self drawInRect:(CGRect){CGPointZero,scaleSize}];
    
    // 获取指定尺寸的图片
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [scaleImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}

/**
 *  返回拉伸后的图片,默认为从中点拉伸
 */
+ (UIImage *)yp_resizeImageWithName:(NSString *)imageName {
    return [self yp_resizeImageWithName:imageName edgeInsets:UIEdgeInsetsZero];
}

/**
 *  返回拉伸后的图片,指定拉伸位置
 */
+ (UIImage *)yp_resizeImageWithName:(NSString *)imageName edgeInsets:(UIEdgeInsets)edgeInsets {
    
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    return image;
}



/**
 *  将方图片转换成圆图片
 */
+ (UIImage *)yp_circleImageWithOldImage:(UIImage *)oldImage borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    // 1.开启上下文
    CGFloat border = borderWidth;
    CGFloat imageW = oldImage.size.width + 2 * border;
    CGFloat imageH = oldImage.size.height + 2 * border;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    // 2.取出当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 3.画边框(大圆)
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5;
    CGFloat centerX = bigRadius;
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx);
    
    // 小圆
    CGFloat smallRadius = bigRadius - border;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, 2 * M_PI, 0);
    CGContextClip(ctx);
    
    // 画图
    [oldImage drawInRect:CGRectMake(border, border, oldImage.size.width, oldImage.size.height)];
    
    // 取图
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //结束上下文
    UIGraphicsEndImageContext();
    
    return image;
    
}

+ (UIImage *)yp_generateCenterImageWithBgColor:(UIColor *)bgImageColor bgImageSize:(CGSize)bgImageSize centerImage:(UIImage *)centerImage
{
    UIImage *bgImage = [UIImage imageWithColor:bgImageColor size:bgImageSize];
    UIGraphicsBeginImageContext(bgImage.size);
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    [centerImage drawInRect:CGRectMake((bgImage.size.width - centerImage.size.width) * 0.5, (bgImage.size.height - centerImage.size.height) * 0.5, centerImage.size.width, centerImage.size.height)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}


@end
