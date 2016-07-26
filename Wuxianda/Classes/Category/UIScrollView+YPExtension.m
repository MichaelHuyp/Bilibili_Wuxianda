//
//  UIScrollView+YPExtension.m
//  YPExtension
//
//  Created by 胡云鹏 on 15/8/18.
//  Copyright (c) 2015年 MichaelPPP. All rights reserved.
//

#import "UIScrollView+YPExtension.h"

@implementation UIScrollView (YPExtension)

- (void)setInsetT:(CGFloat)insetT
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = insetT;
    self.contentInset = inset;
}

- (CGFloat)insetT
{
    return self.contentInset.top;
}

- (void)setInsetB:(CGFloat)insetB
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = insetB;
    self.contentInset = inset;
}

- (CGFloat)insetB
{
    return self.contentInset.bottom;
}

- (void)setInsetL:(CGFloat)insetL
{
    UIEdgeInsets inset = self.contentInset;
    inset.left = insetL;
    self.contentInset = inset;
}

- (CGFloat)insetL
{
    return self.contentInset.left;
}

- (void)setInsetR:(CGFloat)insetR
{
    UIEdgeInsets inset = self.contentInset;
    inset.right = insetR;
    self.contentInset = inset;
}

- (CGFloat)insetR
{
    return self.contentInset.right;
}

- (void)setOffsetX:(CGFloat)offsetX
{
    CGPoint offset = self.contentOffset;
    offset.x = offsetX;
    self.contentOffset = offset;
}

- (CGFloat)offsetX
{
    return self.contentOffset.x;
}

- (void)setOffsetY:(CGFloat)offsetY
{
    CGPoint offset = self.contentOffset;
    offset.y = offsetY;
    self.contentOffset = offset;
}

- (CGFloat)offsetY
{
    return self.contentOffset.y;
}

- (void)setContentW:(CGFloat)contentW
{
    CGSize size = self.contentSize;
    size.width = contentW;
    self.contentSize = size;
}

- (CGFloat)contentW
{
    return self.contentSize.width;
}

- (void)setContentH:(CGFloat)contentH
{
    CGSize size = self.contentSize;
    size.height = contentH;
    self.contentSize = size;
}

- (CGFloat)contentH
{
    return self.contentSize.height;
}

@end
