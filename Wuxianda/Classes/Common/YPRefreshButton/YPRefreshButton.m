//
//  YPRefreshButton.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/14.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPRefreshButton.h"

@interface YPRefreshButton ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;


/** 刷新图标 */
@property (weak, nonatomic) IBOutlet UIImageView *refreshIconImageView;

@end

@implementation YPRefreshButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _bgImageView.layer.cornerRadius = 18;
    _bgImageView.layer.masksToBounds = YES;
}


@end
