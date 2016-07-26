//
//  YPSeparatorLineView.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/8.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPSeparatorLineView.h"

@interface YPSeparatorLineView ()

@property (weak, nonatomic) IBOutlet UIView *lineView;

/** 左侧约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingCons;

@end

@implementation YPSeparatorLineView

#pragma mark - Public
+ (instancetype)separatorLineViewWithLineColor:(UIColor *)lineColor leftMargin:(CGFloat)margin
{
    YPSeparatorLineView *view = [YPSeparatorLineView viewFromXib];
    view.lineView.backgroundColor = lineColor;
    view.leadingCons.constant = margin;
    [view layoutIfNeeded];
    return view;
}

#pragma mark - Override
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // self
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.backgroundColor = YPMainBgColor;
}

@end
