//
//  YPCityPickerButton.m
//  Wuxianda
//
//  Created by 胡云鹏 on 16/7/2.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPCityPickerButton.h"

@implementation YPCityPickerButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.selected) {
        
        self.titleLabel.left = 16;
        
        self.imageView.left = self.titleLabel.right + 4;
        
    }
}

@end
