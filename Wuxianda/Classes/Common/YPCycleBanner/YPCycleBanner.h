//
//  YPCycleBanner.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/11.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  无线轮播图控件封装

#import <UIKit/UIKit.h>

/** 轮播图将要开始拖动发出的通知 */
UIKIT_EXTERN NSString* const kCycleBannerWillBeginDraggingNotification;
/** 轮播图结束滑动发出的通知 */
UIKIT_EXTERN NSString* const kCycleBannerDidEndDeceleratingNotification;

@class YPCycleBanner;
typedef void(^YPCycleBannerBlock)(NSUInteger didselectIndex);


@interface YPCycleBanner : UIView

/** 图片url数组 */
@property (nonatomic, copy) NSArray *models;

/** 自动滚动间隔时间,默认5s */
@property (nonatomic, assign) NSTimeInterval autoScrollTimeInterval;

/**
 *  初始化方法
 *
 *  @param frame            轮播图的frame
 *  @param placeholderImage 占位图片
 *  @param block            block
 *
 *  @return 轮播图实例
 */
+ (instancetype)bannerViewWithFrame:(CGRect)frame placeholderImage:(UIImage *)placeholderImage block:(YPCycleBannerBlock)block;

@end
