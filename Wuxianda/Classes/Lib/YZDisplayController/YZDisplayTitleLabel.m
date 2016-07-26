//
//  YZDisplayTitleLabel.m
//  BuDeJie
//
//  Created by yz on 15/12/4.
//  Copyright © 2015年 yz. All rights reserved.
//

#import "YZDisplayTitleLabel.h"

@implementation YZDisplayTitleLabel

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    
    [_fillColor set];
    
    rect.size.width = rect.size.width * _progress;
    
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceIn);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}


- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    [self setNeedsDisplay];
}

@end
