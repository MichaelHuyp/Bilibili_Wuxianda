//
//  YPBangumiDetailEpisodePickerView.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/24.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  番剧详情剧集选择视图

#import <UIKit/UIKit.h>

typedef void(^YPBangumiDetailEpisodePickerViewBlock)(NSUInteger selectEpisodeIndex);

@interface YPBangumiDetailEpisodePickerView : UIView

+ (instancetype)bangumiDetailEpisodePickerViewWithBlock:(YPBangumiDetailEpisodePickerViewBlock)block;

/**
 *  刷新数据源方法
 *
 *  @param totalCount   总剧集数
 *  @param updateIndex 更新到哪一集
 */
- (void)reloadDataWithTotalCount:(NSUInteger)totalCount updateIndex:(NSUInteger)updateIndex;

/** 存储View的高度 */
@property (nonatomic, assign , readonly) CGFloat viewH;

@end
