//
//  YPLaunchModel.h
//  Wuxianda
//
//  Created by 胡云鹏 on 16/5/21.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

/**
 [
 {
	end_time = 1468425600,
	skip = 1,
	id = 187,
	times = 5,
	start_time = 1468339200,
	animate = 1,
	duration = 2,
	image = http://i0.hdslb.com/bfs/archive/9af95cad7a7d82c3bbbc7b1fe7ca81a9458c5d5b.jpg,
	key = 30e207de2f39bfe2a3bdba150f9c485c,
	type = 0,
	param = bilibili://live/780
 }
 ]
 */

/**
    end_time = 1463745300,
	skip = 0,
	id = 88,
	times = 10,
	start_time = 1463716800,
	animate = 1,
	duration = 2,
	image = http://i0.hdslb.com/bfs/archive/ed1f997d5779e5963bc67021aaa5fb3765f18eef.jpg,
	key = de3e8235efd37e312392d5010dd53720,
	type = 1,
	param =
 */

#import <Foundation/Foundation.h>

@interface YPLaunchModel : NSObject

/** 启动页的结束时间戳 */
@property (nonatomic, copy) NSString *end_time;
/** 启动页的开始时间戳 */
@property (nonatomic, copy) NSString *start_time;
/** 启动页持续的时间 */
@property (nonatomic, copy) NSString *duration;
/** 启动页图片地址 */
@property (nonatomic, copy) NSString *image;
/** 启动页的出现次数 */
@property (nonatomic, copy) NSString *times;

@property (nonatomic, copy) NSString *animate;
@property (nonatomic, copy) NSString *skip;
@property (nonatomic, copy) NSString *idStr;
@property (nonatomic, copy) NSString *key;


/**
 *  type = 0 (广告(3秒读秒) 带链接参数)
 *  type = 1 无参数活动预告
 */
@property (nonatomic, copy) NSString *type;

/**
 *  链接参数
 */
@property (nonatomic, copy) NSString *param;

@end




























