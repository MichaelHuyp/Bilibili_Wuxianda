//
//  YPBangumiContentTableHeaderView.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/20.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPBangumiContentTableHeaderView.h"
#import "YPBangumiHeaderContentViewModel.h"
#import "YPCycleBanner.h"
#import "YPBangumiEntranceIconsView.h"

@interface YPBangumiContentTableHeaderView ()

/** 顶部轮播View */
@property (nonatomic, weak) YPCycleBanner *bannerView;

/** 底部视图 */
@property (nonatomic, weak) YPBangumiEntranceIconsView *bottomView;

@end

@implementation YPBangumiContentTableHeaderView

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
    
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    
    
    _bannerView.frame = CGRectMake(0, 0, YPScreenW, 120);
    _bottomView.frame = CGRectMake(0, _bannerView.bottom, YPScreenW, 160);
    
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
        
        if ([self.myDelegate conformsToProtocol:@protocol(YPBangumiContentTableHeaderViewDelegate)] && [self.myDelegate respondsToSelector:@selector(bangumiContentTableHeaderView:didSelectedBannerIndex:)]) {
            [self.myDelegate bangumiContentTableHeaderView:self didSelectedBannerIndex:didselectIndex];
        }
        
    }];
    _bannerView = bannerView;
    [self addSubview:bannerView];
    
    // 底部入口View
    YPBangumiEntranceIconsView *bottomView = [YPBangumiEntranceIconsView viewFromXib];
    _bottomView = bottomView;
    [self addSubview:bottomView];
}

#pragma mark - Setter
- (void)setVm:(YPBangumiHeaderContentViewModel *)vm
{
    _vm = vm;
    
    
    _bannerView.models = vm.model.banners;
}




@end
