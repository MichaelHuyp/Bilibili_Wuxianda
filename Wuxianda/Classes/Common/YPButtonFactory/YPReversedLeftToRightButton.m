//
//  YPReversedLeftToRightButton.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/8.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPReversedLeftToRightButton.h"

@implementation YPReversedLeftToRightButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.left = 0;
    self.imageView.left = self.titleLabel.right + 4;
}

@end
