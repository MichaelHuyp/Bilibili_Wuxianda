//
//  YPLiveContentModel.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/11.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  直播内容模型

#import <Foundation/Foundation.h>

@interface YPLiveContentModel : NSObject

/** 轮播图数据数组 */
@property (nonatomic, copy) NSArray *banner;

/** 入口图片数据数组 */
@property (nonatomic, copy) NSArray *entranceIcons;

/** 分区数据数组 */
@property (nonatomic, copy) NSArray *partitions;

@end
