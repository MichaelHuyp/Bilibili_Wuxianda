//
//  YPBangumiDetailActivityModel.h
//  Wuxianda
//
//  Created by 胡云鹏 on 16/6/18.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  番剧详情活动模型

#import <Foundation/Foundation.h>

@interface YPBangumiDetailActivityModel : NSObject

/** id */
@property (nonatomic, copy) NSString *idStr;
/** 跳转html */
@property (nonatomic, copy) NSString *appLink;
/** 活动图片url */
@property (nonatomic, copy) NSString *appPicUrl;
/** 活动标题 */
@property (nonatomic, copy) NSString *title;

@end

/**
 {
 "appLink":"http://www.bilibili.com/html/activity-20160525re0.html",
 "appPicUrl":"http://i0.hdslb.com/bfs/bangumi/b5c164a62dc95df3bd830abf8f54bbb9fb5361f5.jpg",
 "id":12,
 "title":"迷家"
 }
 */