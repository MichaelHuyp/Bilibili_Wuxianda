//
//  YPLivePortraitToolView.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/18.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  直播竖屏工具View

#import <UIKit/UIKit.h>

typedef void(^YPLivePortraitToolViewCallBack)(void);

@protocol IJKMediaPlayback;

@interface YPLivePortraitToolView : UIView

/** 代理播放器 */
@property(nonatomic, weak) id<IJKMediaPlayback> delegatePlayer;

+ (instancetype)livePortraitToolViewWithBackBtnDidTouchCallBack:(YPLivePortraitToolViewCallBack)backBtnCallBack fullScreenBtnDidTouchCallBack:(YPLivePortraitToolViewCallBack)fullScreenBtnCallBack;

@end
