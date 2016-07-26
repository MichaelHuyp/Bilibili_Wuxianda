//
//  YPBangumiDetailContractView.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/7.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  番剧详情承包View


#import <UIKit/UIKit.h>
@class YPBangumiDetailRankModel;

@interface YPBangumiDetailContractView : UIView

@property (nonatomic, strong) YPBangumiDetailRankModel *rankModel;


/** 用于记录view的高度 */
@property (nonatomic, assign, readonly) CGFloat viewH;

@end
