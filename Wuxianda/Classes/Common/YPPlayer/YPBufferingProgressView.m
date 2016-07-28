//
//  YPBufferingProgressView.m
//  Wuxianda
//
//  Created by 胡云鹏 on 16/7/25.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPBufferingProgressView.h"

@interface YPBufferingProgressView ()

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@property (weak, nonatomic) IBOutlet UIImageView *loadingImageView;


@end

@implementation YPBufferingProgressView

- (void)awakeFromNib
{
    [super awakeFromNib];
    

}


+ (instancetype)shareInstance
{
    static YPBufferingProgressView *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [YPBufferingProgressView viewFromXib];
    });
    return _instance;
}

+ (void)showInView:(UIView *)view
{
    YPBufferingProgressView *progressView = [YPBufferingProgressView shareInstance];
    [view addSubview:progressView];
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    anim.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    anim.duration = 1;
    anim.cumulative = YES;
    anim.repeatCount = MAXFLOAT;
    [progressView.loadingImageView.layer addAnimation:anim forKey:nil];
    
    [progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(progressView.superview.mas_left).with.offset(0);
        make.centerY.equalTo(progressView.superview.mas_centerY);
        make.height.mas_equalTo(34);
    }];
}

+ (void)dismiss
{
    [[YPBufferingProgressView shareInstance] removeFromSuperview];
}

- (void)setProgress:(NSUInteger)progress
{
    if (progress <= 0) {
        progress = 0;
    }
    if (progress >= 99) {
        progress = 99;
    }
    
    if (progress == 0) {
        self.progressLabel.text = @"正在缓冲";
    } else {
        self.progressLabel.text = [NSString stringWithFormat:@"正在缓冲：%lu%%",progress];
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.width = self.progressLabel.right + 8;
}

@end







































