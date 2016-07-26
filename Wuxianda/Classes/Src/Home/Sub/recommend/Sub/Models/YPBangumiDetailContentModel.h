//
//  YPBangumiDetailContentModel.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/17.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  番剧详情内容模型

#import <Foundation/Foundation.h>
#import "YPBangumiDetailActivityModel.h"
#import "YPBangumiDetailRankModel.h"
#import "YPBangumiDetailUser_seasonModel.h"
#import "YPBangumiDetailEpisodesModel.h"

@interface YPBangumiDetailContentModel : NSObject

/** 活动模型 */
@property (nonatomic, strong) YPBangumiDetailActivityModel *activity;
/** 演员数组 */
@property (nonatomic, copy) NSArray *actor;
/** 剧集数组 */
@property (nonatomic, copy) NSArray *episodes;
/** rank模型 */
@property (nonatomic, strong) YPBangumiDetailRankModel *rank;
/** related_seasons数组 */
@property (nonatomic, copy) NSArray *related_seasons;
/** seasons数组 */
@property (nonatomic, copy) NSArray *seasons;
/** tag2s数组 */
@property (nonatomic, copy) NSArray *tag2s;
/** tags数组 */
@property (nonatomic, copy) NSArray *tags;
/** user_season模型 */
@property (nonatomic, strong) YPBangumiDetailUser_seasonModel *user_season;

@property (nonatomic, copy) NSString *allow_bp;
@property (nonatomic, copy) NSString *allow_download;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *arealimit;
@property (nonatomic, copy) NSString *bangumi_id;
/** 番剧名称 */
@property (nonatomic, copy) NSString *bangumi_title;
@property (nonatomic, copy) NSString *brief;
@property (nonatomic, copy) NSString *coins;
@property (nonatomic, copy) NSString *copyright;
/** 番剧logo */
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *danmaku_count;
@property (nonatomic, copy) NSString *evaluate;
/** 订阅数 */
@property (nonatomic, copy) NSString *favorites;
/** 是否已完结 */
@property (nonatomic, copy) NSString *is_finish;
@property (nonatomic, copy) NSString *newest_ep_id;
/** 最新剧集 */
@property (nonatomic, copy) NSString *newest_ep_index;
/** 播放数 */
@property (nonatomic, copy) NSString *play_count;
@property (nonatomic, copy) NSString *pub_time;
@property (nonatomic, copy) NSString *season_id;
/** 第几季 */
@property (nonatomic, copy) NSString *season_title;
@property (nonatomic, copy) NSString *share_url;
/** 番剧方形logo */
@property (nonatomic, copy) NSString *squareCover;
@property (nonatomic, copy) NSString *staff;
/** 番剧标题 */
@property (nonatomic, copy) NSString *title;
/** 总剧集数 */
@property (nonatomic, copy) NSString *total_count;
@property (nonatomic, copy) NSString *viewRank;
@property (nonatomic, copy) NSString *watchingCount;
/** 每周几更新 */
@property (nonatomic, copy) NSString *weekday;

@end

/**
 "result":{
 "activity":Object{...},
 "actor":Array[11],
 "allow_bp":"1",
 "allow_download":"1",
 "area":"日本",
 "arealimit":30,
 "bangumi_id":"2110",
 "bangumi_title":"迷家",
 "brief":"在基于兴趣而参加的可疑巴士旅行当中会合的30名年轻男女。旅行的目的地是名为纳鸣村的、无从确定其存在的...",
 "coins":"29016",
 "copyright":"dujia",
 "cover":"http://i0.hdslb.com/bfs/bangumi/14c8c6b5ef00691639248b2efc5540c72056954f.jpg",
 "danmaku_count":"514419",
 "episodes":Array[12],
 "evaluate":"在基于兴趣而参加的可疑巴士旅行当中会合的30名年轻男女。旅行的目的地是名为纳鸣村的、无从确定其存在的幻影之村。在“纳鸣村”能够不受现世的羁绊束缚，如同乌托邦一般地生活……他们低语着，这如同都市传说般的话语。对现实的世界绝望了……想要逃离无聊的日常……想要让人生重来……。 载着怀抱各自的思绪及心中伤痛的30人，巴士驶向大山深处……。之后，30人所到达的地方是，早已腐朽、毫无生活气息的无人集落。 30人到达的“纳鸣村”的真相究竟是？",
 "favorites":"568919",
 "is_finish":"0",
 "newest_ep_id":"89156",
 "newest_ep_index":"12",
 "play_count":"10717202",
 "pub_time":"2016-04-02 00:00:00",
 "rank":Object{...},
 "related_seasons":Array[0],
 "season_id":"3451",
 "season_title":"迷家",
 "seasons":Array[1],
 "share_url":"http://bangumi.bilibili.com/anime/3451/",
 "squareCover":"http://i0.hdslb.com/bfs/bangumi/e8b014ac131db47b267d1ac3a04417267ec857a6.jpg",
 "staff":"原作：Diomedéa、波丽佳音 监督：水岛努 系列构成：冈田麿里 角色设计：井出直美 音响监督：水岛努 音响制作：スタジオマウス 音乐：横山克 音乐制作：波丽佳音 动画制作：Diomedéa",
 "tag2s":Array[0],
 "tags":Array[3],
 "title":"迷家",
 "total_count":"12",
 "user_season":Object{...},
 "viewRank":0,
 "watchingCount":"0",
 "weekday":"6"
 }
 */
