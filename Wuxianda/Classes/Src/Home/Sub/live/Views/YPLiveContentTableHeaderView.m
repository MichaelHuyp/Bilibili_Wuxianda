//
//  YPLiveContentTableHeaderView.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/12.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPLiveContentTableHeaderView.h"
#import "YPCycleBanner.h"
#import "YPLiveContentViewModel.h"

@interface YPLiveContentTableHeaderView ()

/** 底部入口View */
@property (nonatomic, weak) YPLiveEntranceIconsView *bottomView;

/** 顶部轮播View */
@property (nonatomic, weak) YPCycleBanner *bannerView;


@end

@implementation YPLiveContentTableHeaderView

#pragma mark - Public
+ (instancetype)liveContentTableHeaderView;
{
    return [[self alloc] init];
}

#pragma mark - Override
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (!self) return nil;
    
    [self setup];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (!self) return nil;
    
    [self setup];
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    _bannerView.frame = CGRectMake(0, 0, YPScreenW, 120);
    _bottomView.frame = CGRectMake(0, _bannerView.bottom, YPScreenW, YPScreenW * 0.5 + kAppTabBarHeight + kAppPadding_8);
    
    self.viewH = _bottomView.bottom;
}

#pragma mark - Private
- (void)setup
{
    // self
    self.backgroundColor = YPMainBgColor;
    
    // 轮播控件
    @weakify(self);
    YPCycleBanner *bannerView = [YPCycleBanner bannerViewWithFrame:CGRectMake(0, 0, YPScreenW, 120) placeholderImage:nil block:^(NSUInteger didselectIndex) {
       
        @strongify(self);
        
        if ([self.myDelegate conformsToProtocol:@protocol(YPLiveContentTableHeaderDelegate)] && [self.myDelegate respondsToSelector:@selector(liveContentTableHeaderView:didSelectedBannerIndex:)]) {
            [self.myDelegate liveContentTableHeaderView:self didSelectedBannerIndex:didselectIndex];
        }
        
    }];
    _bannerView = bannerView;
    [self addSubview:bannerView];
    
    // 底部入口View
    YPLiveEntranceIconsView *bottomView = [YPLiveEntranceIconsView liveEntranceIconsViewWithBlock:^(YPLiveEntranceIconsViewAreaType selectedAreaID) {
        
        @strongify(self);
        
        if ([self.myDelegate conformsToProtocol:@protocol(YPLiveContentTableHeaderDelegate)] && [self.myDelegate respondsToSelector:@selector(liveContentTableHeaderView:selectedAreaID:)]) {
            [self.myDelegate liveContentTableHeaderView:self selectedAreaID:selectedAreaID];
        }
        
    }];
    _bottomView = bottomView;
    [self addSubview:bottomView];
}

#pragma mark - Setter
- (void)setVm:(YPLiveContentViewModel *)vm
{
    _vm = vm;
    
    _bannerView.models = vm.model.banner;
    
    _bottomView.entranceIconArray = vm.model.entranceIcons;
}

@end























