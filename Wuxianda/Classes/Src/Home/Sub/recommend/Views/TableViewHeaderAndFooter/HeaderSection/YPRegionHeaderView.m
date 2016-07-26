//
//  YPRegionHeaderView.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/14.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPRegionHeaderView.h"

@interface YPRegionHeaderView ()

/** 标题名称标签 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 图标 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
/** 详情标签 */
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation YPRegionHeaderView


+ (instancetype)regionHeaderViewWithTitle:(NSString *)title icon:(UIImage *)image detailContent:(NSString *)detailContent
{
    YPRegionHeaderView *view = [YPRegionHeaderView viewFromXib];
    view.titleLabel.text = title;
    view.iconImageView.image = image;
    if ([detailContent isNotBlank]) {
        view.detailLabel.text = detailContent;
    } else {
        view.detailLabel.text = @"进去看看";
    }
    return view;
}

@end
