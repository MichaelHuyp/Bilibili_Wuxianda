//
//  YPBilibiliNormalRefresh.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/15.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPBilibiliNormalRefresh.h"

@interface YPBilibiliNormalRefresh ()

@property (nonatomic, weak) UIImageView *logoImageView;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIImageView *arrowImageView;

@property (weak, nonatomic) UIActivityIndicatorView *loading;

@property (nonatomic, strong) NSMutableArray *animateImages;

@end

@implementation YPBilibiliNormalRefresh

- (NSMutableArray *)animateImages
{
    if (!_animateImages) {
        _animateImages = [NSMutableArray array];
        for (int i = 1; i <= 4; i++) {
            
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_logo_%d",i]];
            
            [_animateImages addObject:image];
        }
    }
    return _animateImages;
}

- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 88;
    
    
    // 添加子控件
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh_logo_1"]];
    _logoImageView = logoImageView;
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:logoImageView];
    
    // 标签
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    titleLabel.textColor = YPBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"再拉，再拉就刷给你看";
    titleLabel.hidden = NO;
    [titleLabel sizeToFit];
    [self addSubview:titleLabel];
    
    // arrow
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    _arrowImageView = arrowImageView;
    arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:arrowImageView];
    
    // loading
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _loading = loading;
    [self addSubview:loading];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    _logoImageView.centerX = self.mj_w * 0.5;
    _logoImageView.top = 6;
    
    _arrowImageView.top = _logoImageView.bottom - 2;
    _arrowImageView.right = _logoImageView.left + 14;
    
    _loading.center = _arrowImageView.center;
    
    _titleLabel.left = _arrowImageView.right + 2;
    _titleLabel.top = _logoImageView.bottom + 6;
}


#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    if (self.state == MJRefreshStateIdle) {
        
        CGPoint offset = [change[@"new"] CGPointValue];
        
        if (offset.x == 0) {
            _titleLabel.text = @"再拉，再拉就刷给你看";
            [_titleLabel sizeToFit];
        }
    }
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    // 根据状态做事情
    switch (state) {
        case MJRefreshStateIdle:
        {
            if (oldState == MJRefreshStateRefreshing) {
                _arrowImageView.transform = CGAffineTransformIdentity;
                _titleLabel.text = @"刷呀刷呀，刷完啦，喵^ω^";
                [_titleLabel sizeToFit];
                [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                    _loading.alpha = 0.0;
                } completion:^(BOOL finished) {
                    // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                    if (self.state != MJRefreshStateIdle) return;
                    _loading.alpha = 1.0;
                    [_loading stopAnimating];
                    [_logoImageView stopAnimating];
                    _arrowImageView.hidden = NO;
                }];
            } else {
                _titleLabel.text = @"再拉，再拉就刷给你看";
                [_titleLabel sizeToFit];
                [_loading stopAnimating];
                [_logoImageView stopAnimating];
                _arrowImageView.hidden = NO;
                [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                    _arrowImageView.transform = CGAffineTransformIdentity;
                }];
            }
            
            break;
        }
        case MJRefreshStatePulling:
        {
            [_loading stopAnimating];
            _arrowImageView.hidden = NO;
            _titleLabel.text = @"够了啦，松开人家嘛";
            [_titleLabel sizeToFit];
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                _arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
            }];
            
            break;
        }
        case MJRefreshStateRefreshing:
        {
            _loading.alpha = 1.0; // 防止refreshing -> idle的动画完毕动作没有被执行
            [_loading startAnimating];
            _arrowImageView.hidden = YES;
            _logoImageView.animationImages = self.animateImages;
            [_logoImageView startAnimating];
            _titleLabel.text = @"刷呀刷呀，好累啊，喵^ω^";
            [_titleLabel sizeToFit];
            break;
        }
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
}


@end



































































