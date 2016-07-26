//
//  YPBannerModel.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/5/31.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  轮播图模型

/**
 weight = 300,
 remark = ,
 hash = e2a27aed520f6c00aacb4dda2efd7170,
 title = 31,
 image = http://i0.hdslb.com/bfs/archive/dadb17503b7fe238bda690961a0ba4991d91c61f.png,
 value = https://itunes.apple.com/cn/app/id1076496388,
 type = 2
 */

#import <Foundation/Foundation.h>

@interface YPBannerModel : NSObject

/** 重量 */
@property (nonatomic, copy) NSString *weight;
/** 备注 */
@property (nonatomic, copy) NSString *remark;
/** 哈希值 */
@property (nonatomic, copy) NSString *hashStr;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 轮播图 */
@property (nonatomic, copy) NSString *image;

/**
 *  跳转值
 *  2 : html网页网址
 *  3 : 跳转电视剧的value标识(season_id)
 */
@property (nonatomic, copy) NSString *value;
/**
 *  跳转类型
 *  2 : html网页
 *  3 : 跳转电视剧页面
 */
@property (nonatomic, copy) NSString *type;

@end
