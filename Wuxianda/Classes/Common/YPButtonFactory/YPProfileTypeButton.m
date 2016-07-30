//
//  YPProfileTypeButton.m
//  Wuxianda
//
//  Created by 胡云鹏 on 16/7/30.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPProfileTypeButton.h"

@implementation YPProfileTypeButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.size = CGSizeMake(30, 30);
    self.titleLabel.width = self.width;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.imageView.centerX = self.width * 0.5;
    self.imageView.centerY = self.width * 0.5 - self.imageView.width * 0.5 + 6;

    
    self.titleLabel.centerX = self.imageView.centerX;
    self.titleLabel.top = self.imageView.bottom + 8;
}

@end
