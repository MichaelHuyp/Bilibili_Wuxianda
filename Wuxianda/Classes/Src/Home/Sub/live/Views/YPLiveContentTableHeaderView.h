//
//  YPLiveContentTableHeaderView.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/12.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  直播内容头视图

#import <UIKit/UIKit.h>
#import "YPLiveEntranceIconsView.h"

@class YPLiveContentViewModel;
@protocol YPLiveContentTableHeaderDelegate;


typedef void(^YPLiveContentTableHeaderViewBlock)(NSUInteger didSelectedBannerIndex,YPLiveEntranceIconsViewAreaType selectedAreaID);

@interface YPLiveContentTableHeaderView : UIView

@property (nonatomic, strong) YPLiveContentViewModel *vm;

+ (instancetype)liveContentTableHeaderView;

/** 记录头部视图的高度 */
@property (nonatomic, assign) CGFloat viewH;

@property (nonatomic, weak) id<YPLiveContentTableHeaderDelegate> myDelegate;

@end


@protocol YPLiveContentTableHeaderDelegate <NSObject>

@optional

/**
 *  轮播图点击触发的代理
 *
 *  @param didSelectedBannerIndex     轮播索引
 */
- (void)liveContentTableHeaderView:(YPLiveContentTableHeaderView *)liveContentTableHeaderView didSelectedBannerIndex:(NSUInteger)index;

/**
 *  入口图标被点击触发的索引
 *
 *  @param selectedAreaID             入口图标索引
 */
- (void)liveContentTableHeaderView:(YPLiveContentTableHeaderView *)liveContentTableHeaderView selectedAreaID:(YPLiveEntranceIconsViewAreaType)areaID;

@end















