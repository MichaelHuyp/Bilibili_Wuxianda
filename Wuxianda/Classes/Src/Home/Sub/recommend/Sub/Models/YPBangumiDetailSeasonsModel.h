//
//  YPBangumiDetailSeasonsModel.h
//  Wuxianda
//
//  Created by 胡云鹏 on 16/6/18.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  番剧的季节种类

#import <Foundation/Foundation.h>

@interface YPBangumiDetailSeasonsModel : NSObject

@property (nonatomic, copy) NSString *bangumi_id;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *is_finish;
@property (nonatomic, copy) NSString *is_new;
@property (nonatomic, copy) NSString *newest_ep_id;
/** 当前更新到多少集 */
@property (nonatomic, copy) NSString *newest_ep_index;
@property (nonatomic, copy) NSString *season_id;
/** 标签名字 */
@property (nonatomic, copy) NSString *title;
/** 一共有多少集 */
@property (nonatomic, copy) NSString *total_count;

@end

/**
 {
 "bangumi_id":"2110",
 "cover":"http://i0.hdslb.com/bfs/bangumi/14c8c6b5ef00691639248b2efc5540c72056954f.jpg",
 "is_finish":"0",
 "is_new":"1",
 "newest_ep_id":"89156",
 "newest_ep_index":"12",
 "season_id":"3451",
 "title":"迷家",
 "total_count":"12"
 }
 */