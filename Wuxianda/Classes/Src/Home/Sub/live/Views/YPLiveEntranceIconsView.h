//
//  YPLiveEntranceIconsView.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/12.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  入口图标View

#import <UIKit/UIKit.h>

/**
 *  选择入口图标的类型
 */
typedef NS_ENUM(NSInteger, YPLiveEntranceIconsViewAreaType) {
    /**
     *  单机联机 id = 1
     */
    YPLiveEntranceIconsViewAreaTypeSingle = 1,
    /**
     *  网络游戏 id = 3
     */
    YPLiveEntranceIconsViewAreaTypeGameOnline = 3,
    /**
     *  电子竞技 id = 4
     */
    YPLiveEntranceIconsViewAreaTypeESports = 4,
    /**
     *  萌宅推荐 id = 8
     */
    YPLiveEntranceIconsViewAreaTypeMeng = 8,
    /**
     *  绘画专区 id = 9
     */
    YPLiveEntranceIconsViewAreaTypePainting = 9,
    /**
     *  手机直播 id = 11
     */
    YPLiveEntranceIconsViewAreaTypeLivePhone = 11,
    /**
     *  全部分类 id = 10086
     */
    YPLiveEntranceIconsViewAreaTypeAllCategory = 10086,
    /**
     *  全部直播 id = 10087
     */
    YPLiveEntranceIconsViewAreaTypeAllLive,
    /**
     *  关注主播 id = 10088
     */
    YPLiveEntranceIconsViewAreaTypeAttentionAuthor,
    /**
     *  直播中心 id = 10089
     */
    YPLiveEntranceIconsViewAreaTypeLiveCenter,
    /**
     *  搜索直播 id = 10090
     */
    YPLiveEntranceIconsViewAreaTypeSearchLive
};

typedef void(^YPLiveEntranceIconsViewBlock)(YPLiveEntranceIconsViewAreaType selectedAreaID);

@interface YPLiveEntranceIconsView : UIView

@property (nonatomic, copy) NSArray *entranceIconArray;

+ (instancetype)liveEntranceIconsViewWithBlock:(YPLiveEntranceIconsViewBlock)block;

@end

















































