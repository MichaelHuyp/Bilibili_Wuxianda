//
//  YPBangumiContentTableHeaderView.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/20.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YPBangumiHeaderContentViewModel;
@protocol YPBangumiContentTableHeaderViewDelegate;

@interface YPBangumiContentTableHeaderView : UIView


@property (nonatomic, strong) YPBangumiHeaderContentViewModel *vm;

/** 记录头部视图的高度 */
@property (nonatomic, assign) CGFloat viewH;

@property (nonatomic, weak) id<YPBangumiContentTableHeaderViewDelegate> myDelegate;


@end

@protocol YPBangumiContentTableHeaderViewDelegate <NSObject>

@optional

/**
 *  轮播图点击触发的代理
 *
 *  @param didSelectedBannerIndex     轮播索引
 */
- (void)bangumiContentTableHeaderView:(YPBangumiContentTableHeaderView *)bangumiContentTableHeaderView didSelectedBannerIndex:(NSUInteger)index;


@end