//
//  YPHomeController.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/1/21.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPHomeController.h"
#import "YPLiveViewController.h"
#import "YPPartitionViewController.h"
#import "YPRecommendViewController.h"
#import "YPBangumiViewController.h"


@interface YPHomeController ()

@end

@implementation YPHomeController

#pragma mark - 屏幕旋转控制方法
- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - Override
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // self
    self.view.backgroundColor = YPWhiteColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.autoresizingMask = UIViewAutoresizingNone;
    
    self.fd_prefersNavigationBarHidden = NO;
    
    // 添加所有子控制器
    [self setUpAllViewController];
    
    // 设置字体
    self.titleFont = [UIFont systemFontOfSize:17];
    
    // 根据角标，选中对应的控制器
    self.selectIndex = 1;
    
    // *推荐方式(设置标题渐变)
    [self setUpTitleGradient:^(BOOL *isShowTitleGradient, YZTitleColorGradientStyle *titleColorGradientStyle, CGFloat *startR, CGFloat *startG, CGFloat *startB, CGFloat *endR, CGFloat *endG, CGFloat *endB) {
        // 不需要设置的属性，可以不管
        *isShowTitleGradient = YES;
        *titleColorGradientStyle = YZTitleColorGradientStyleRGB;
        *startR = 0.66;
        *startG = 0.65;
        *startB = 0.66;
        *endR = 0.89f;
        *endG = 0.49f;
        *endB = 0.61f;
    }];
    
    // 推荐方式（设置下标）
    [self setUpUnderLineEffect:^(BOOL *isShowUnderLine, BOOL *isDelayScroll, CGFloat *underLineH, UIColor *__autoreleasing *underLineColor) {
        // 是否显示标签
        *isShowUnderLine = YES;
        
        *underLineH = 3;
        
        // 标题填充模式
        *underLineColor = YPMainColor;
    }];
    
    /**
     如果_isfullScreen = Yes，这个方法就不好使。
     
     设置整体内容的frame,包含（标题滚动视图和内容滚动视图）
     */
    [self setUpContentViewFrame:^(UIView *contentView) {
        contentView.frame = CGRectMake(0, 20, YPScreenW, YPScreenH - 20);
    }];
    
    self.isBisectedWidthUnderLineAndTitle = YES;
    
    // 订阅轮播图开始滑动以及结束滑动的通知改变首页内容视图是否可以滑动
    @weakify(self);
    [[YPNotificationCenter rac_addObserverForName:kBannerViewWillBeginDraggingNotification object:nil] subscribeNext:^(id x) {
        @strongify(self);
        self.isBanContentViewScroll = YES;
    }];
    
    [[YPNotificationCenter rac_addObserverForName:kBannerViewDidEndDeceleratingNotification object:nil] subscribeNext:^(id x) {
        @strongify(self);
        self.isBanContentViewScroll = NO;
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [YPApplication setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [YPApplication setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    self.navigationController.navigationBar.alpha = 0.0f;
    [self.navigationController.navigationBar.superview sendSubviewToBack:self.navigationController.navigationBar];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.navigationController.navigationBar.alpha = 0.0f;
    [self.navigationController.navigationBar.superview sendSubviewToBack:self.navigationController.navigationBar];
}


- (void)dealloc
{
    [YPRequestTool cancel];
    [YPNotificationCenter removeObserver:self];
}

#pragma mark - Private
// 添加所有子控制器
- (void)setUpAllViewController
{
    
    // 直播
    YPLiveViewController *vc1 = [YPLiveViewController controller];
    vc1.title = @"直播";
    [self addChildViewController:vc1];
    
    // 推荐
    YPRecommendViewController *vc2 = [YPRecommendViewController controller];
    vc2.title = @"推荐";
    [self addChildViewController:vc2];
    
    // 番剧
    YPBangumiViewController *vc3 = [YPBangumiViewController controller];
    vc3.title = @"番剧";
    [self addChildViewController:vc3];
    
    // 分区
    YPPartitionViewController *vc4 = [YPPartitionViewController controller];
    vc4.title = @"分区";
    [self addChildViewController:vc4];
    
}




@end
