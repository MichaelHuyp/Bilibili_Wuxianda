//
//  YPLiveLandscapeToolView.h
//  Wuxianda
//
//  Created by 胡云鹏 on 16/7/26.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YPLiveModel;

@protocol IJKMediaPlayback,YPLiveLandscapeToolViewDelegate;

@interface YPLiveLandscapeToolView : UIView

/** 直播模型 */
@property (nonatomic, strong) YPLiveModel *liveModel;

/** 代理播放器 */
@property(nonatomic, weak) id<IJKMediaPlayback> delegatePlayer;

/** 代理 */
@property (nonatomic, weak) id<YPLiveLandscapeToolViewDelegate> myDelegate;

@end

@protocol YPLiveLandscapeToolViewDelegate <NSObject>

@optional
/** 转换为竖屏 */
- (void)liveLandscapeToolViewPortraitBtnDidTouch:(YPLiveLandscapeToolView *)liveLandscapeToolView;

@end