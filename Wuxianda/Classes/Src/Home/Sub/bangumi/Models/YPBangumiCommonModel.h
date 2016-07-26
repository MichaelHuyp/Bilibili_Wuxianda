//
//  YPBangumiCommonModel.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/20.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  普通番剧模型

#import <Foundation/Foundation.h>

@interface YPBangumiCommonModel : NSObject

/** 封面 */
@property (nonatomic, copy) NSString *cover;

/** 时间戳 */
@property (nonatomic, copy) NSString *last_time;

@property (nonatomic, copy) NSString *newest_ep_id;

@property (nonatomic, copy) NSString *newest_ep_index;

@property (nonatomic, copy) NSString *season_id;

/** 标题 */
@property (nonatomic, copy) NSString *title;

/** 总集数 */
@property (nonatomic, copy) NSString *total_count;

/** 观看人数 */
@property (nonatomic, copy) NSString *watchingCount;

@end
