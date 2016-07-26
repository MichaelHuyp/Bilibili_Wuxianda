//
//  UIView+YPLayer.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/8.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "UIView+YPLayer.h"

@implementation UIView (YPLayer)

- (void)setLayerBorderWidth:(CGFloat)layerBorderWidth
{
    self.layer.borderWidth = layerBorderWidth;
    [self _config];
}

- (CGFloat)layerBorderWidth
{
    return self.layer.borderWidth;
}

- (void)setLayerCornerRadius:(CGFloat)layerCornerRadius
{
    self.layer.cornerRadius = layerCornerRadius;
    [self _config];
}

- (CGFloat)layerCornerRadius
{
    return self.layer.cornerRadius;
}

- (void)setLayerBorderColor:(UIColor *)layerBorderColor
{
    self.layer.borderColor = layerBorderColor.CGColor;
    [self _config];
}

- (UIColor *)layerBorderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)_config
{
    self.layer.masksToBounds = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.shouldRasterize = YES;
}

@end
