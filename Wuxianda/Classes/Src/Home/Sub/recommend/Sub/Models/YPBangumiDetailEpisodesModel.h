//
//  YPBangumiDetailEpisodesModel.h
//  Wuxianda
//
//  Created by 胡云鹏 on 16/6/18.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YPEpisodesUpModel.h"

@interface YPBangumiDetailEpisodesModel : NSObject

@property (nonatomic, strong) YPEpisodesUpModel *up;


@property (nonatomic, copy) NSString *av_id;
@property (nonatomic, copy) NSString *coins;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *danmaku;
/** 剧集id */
@property (nonatomic, copy) NSString *episode_id;
/** 第几集索引 */
@property (nonatomic, copy) NSString *index;
/** 标题 */
@property (nonatomic, copy) NSString *index_title;
@property (nonatomic, copy) NSString *is_new;
@property (nonatomic, copy) NSString *is_webplay;
@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *page;
@property (nonatomic, copy) NSString *update_time;


@end

/**
 {
 "av_id":"5004210",
 "coins":"341",
 "cover":"http://i1.hdslb.com/bfs/archive/582639eebc9b85358debfc654f4277e5af307c5f.jpg",
 "danmaku":"8128226",
 "episode_id":"89156",
 "index":"12",
 "index_title":"Nanaki乃心灵之镜",
 "is_new":"1",
 "is_webplay":"0",
 "mid":"928123",
 "page":"1",
 "up":{
 
 },
 "update_time":"2016-06-18 09:30:02.0"
 }
 */