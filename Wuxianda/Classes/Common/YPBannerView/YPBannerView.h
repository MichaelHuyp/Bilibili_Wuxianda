//
//  YPBannerView.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/5/31.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YPBannerView;

/** 轮播图将要开始拖动发出的通知 */
UIKIT_EXTERN NSString* const kBannerViewWillBeginDraggingNotification;
/** 轮播图结束滑动发出的通知 */
UIKIT_EXTERN NSString* const kBannerViewDidEndDeceleratingNotification;

typedef void(^YPBannerViewBlock)(NSUInteger didselectIndex);

@interface YPBannerView : UIView

/** 模型数组 */
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
+ (instancetype)bannerViewWithFrame:(CGRect)frame placeholderImage:(UIImage *)placeholderImage block:(YPBannerViewBlock)block;

@end
