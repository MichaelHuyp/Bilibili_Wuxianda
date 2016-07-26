//
//  YPVerticalButton.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/12.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPVerticalButton.h"

@implementation YPVerticalButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.centerX = self.width * 0.5;
    self.imageView.centerY = self.width * 0.5 - self.imageView.width * 0.5 + 12;
    
    self.titleLabel.centerX = self.imageView.centerX;
    self.titleLabel.top = self.imageView.bottom + 4;
}

@end
