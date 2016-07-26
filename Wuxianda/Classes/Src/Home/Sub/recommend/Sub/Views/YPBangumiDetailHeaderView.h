//
//  YPBangumiDetailHeaderView.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/21.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  番剧详情头部视图

#import <UIKit/UIKit.h>
@class YPBangumiDetailContentViewModel;

typedef void(^YPBangumiDetailHeaderViewBlock)(NSUInteger selectEpisodeIndex);

@interface YPBangumiDetailHeaderView : UIView

@property (nonatomic, strong) YPBangumiDetailContentViewModel *vm;

+ (instancetype)bangumiDetailHeaderViewWithBlock:(YPBangumiDetailHeaderViewBlock)block;

/** 记录view的高度 */
@property (nonatomic, assign) CGFloat viewH;

@end
