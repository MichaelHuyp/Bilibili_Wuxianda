//
//  YPRecommendContentBodyModel.h
//  Wuxianda
//
//  Created by 胡云鹏 on 16/6/9.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

/**
 "title":"【MMD】V家众人看恐怖预告片的反应（卖萌注意）",
 "cover":"http://i0.hdslb.com/bfs/archive/f98f9813f71c388be527363bca6f8bd74116ef6f.jpg",
 "param":"4887197",
 "play":81598,
 "danmaku":839,
 "finish":0
 
 
 "title":"新人小涅，请多多指教",
 "cover":"http://i0.hdslb.com/bfs/live/cb6a9da31c8c2bceb2bc3407469fe2bb707f4e32.jpg",
 "param":"179881",
 "name":"涅Elf",
 "face":"http://i1.hdslb.com/bfs/face/f30f3b7a7bb0b5e95845b3fedb5a530c72b14376.jpg",
 "online":51,
 "finish":0
 
 "title":"鬼斩",
 "cover":"http://i2.hdslb.com/bfs/archive/3010bbf98140d47c77350cedac4f42201e018974.jpg",
 "param":"3454",
 "finish":0,
 "index":"10",
 "mtime":"2016-06-09 00:05:02.0"
 
 
 "title":"遥望宇宙",
 "cover":"http://i0.hdslb.com/bfs/archive/4325ca55cb38f732df34c7ffc8b2a0dadced253b.jpg",
 "param":"http://www.bilibili.com/topic/v2/phone1287.html",
 "finish":0
 
 
 "title":"家，N次方",
 "cover":"http://i0.hdslb.com/bfs/archive/42b0a84475e1806d4a8b156ac4eded377baeeb41.jpg",
 "param":"64973",
 "finish":0,
 "index":"30"
 
 */

#import <Foundation/Foundation.h>

@interface YPRecommendContentBodyModel : NSObject

/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 内容图片url */
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *param;
@property (nonatomic, copy) NSString *finish;


#pragma mark - 以下是模型间的差异

#pragma mark 普通类型
/** 播放数 */
@property (nonatomic, copy) NSString *play;
/** 弹幕数 */
@property (nonatomic, copy) NSString *danmaku;

#pragma mark 直播类型
/** up主名字 */
@property (nonatomic, copy) NSString *name;
/** up主头像 */
@property (nonatomic, copy) NSString *face;
/** 在线观看人数 */
@property (nonatomic, copy) NSString *online;

#pragma mark 番剧类型
/** 第几话 */
@property (nonatomic, copy) NSString *index;
/** 番剧更新时间 */
@property (nonatomic, copy) NSString *mtime;

@end









































