//
//  YPRefreshTypeButton.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/15.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPRefreshTypeButton.h"

@implementation YPRefreshTypeButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.left = 0;
    self.imageView.left = self.titleLabel.right;
}

@end
