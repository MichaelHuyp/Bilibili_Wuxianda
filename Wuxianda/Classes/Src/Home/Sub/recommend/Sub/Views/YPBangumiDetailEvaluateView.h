//
//  YPBangumiDetailEvaluateView.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/7.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  番剧简介View

#import <UIKit/UIKit.h>
@class YPBangumiDetailContentModel;

@interface YPBangumiDetailEvaluateView : UIView

@property (nonatomic, strong) YPBangumiDetailContentModel *contentModel;


/** 用来记录view的高度 */
@property (nonatomic, assign, readonly) CGFloat viewH;

@end
