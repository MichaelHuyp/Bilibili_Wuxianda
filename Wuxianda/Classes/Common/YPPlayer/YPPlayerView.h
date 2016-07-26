//
//  YPPlayerView.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/18.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  播放器View

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>

@class YPLiveModel;

typedef NS_ENUM(NSInteger, YPPlayerViewFullScreenStyle) {
    YPPlayerViewFullScreenStylePhoneLive, // 手机直播
    YPPlayerViewFullScreenStyleNormal // 普通横屏
};

typedef void(^YPPlayerViewCallBack)(void);

@interface YPPlayerView : UIView

/** 视频Url */
@property (nonatomic, strong) NSURL *videoUrl;

/** 视频拉伸模式 */
@property (nonatomic, assign) IJKMPMovieScalingMode scaleMode;

/** 视频全屏模式类型 */
@property (nonatomic, assign) YPPlayerViewFullScreenStyle liveStyle;

/** 视频缩略图 */
@property (nonatomic, strong, readonly) UIImage *thumbnailImageAtCurrentTime;

/** 直播模型 */
@property (nonatomic, strong) YPLiveModel *liveModel;

- (void)playerViewBackCallBack:(YPPlayerViewCallBack)callBack;
- (void)playerViewFullScreenCallBack:(YPPlayerViewCallBack)callBack;

- (void)play;
- (void)pause;
- (void)prepareToPlay;
- (void)stop;
- (BOOL)isPlaying;
- (void)shutdown;

@end
