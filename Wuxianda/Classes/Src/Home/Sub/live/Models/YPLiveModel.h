//
//  YPLiveModel.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/11.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  直播模型

#import <Foundation/Foundation.h>
#import "YPLiveOwnerModel.h"
#import "YPLiveCoverModel.h"

@interface YPLiveModel : NSObject

/** 直播作者模型 */
@property (nonatomic, strong) YPLiveOwnerModel *owner;

/** 直播封面模型 */
@property (nonatomic, strong) YPLiveCoverModel *cover;

/** 标题 */
@property (nonatomic, copy) NSString *title;

/** 房间号 */
@property (nonatomic, copy) NSString *room_id;

/** 检查版本 */
@property (nonatomic, copy) NSString *check_version;

/** online */
@property (nonatomic, copy) NSString *online;

/** 分类 */
@property (nonatomic, copy) NSString *area;

/** 分类id */
@property (nonatomic, copy) NSString *area_id;

/** 直播url */
@property (nonatomic, copy) NSString *playurl;

/** 接收质量? */
@property (nonatomic, copy) NSString *accept_quality;

/**
 广播类型
 0 : 普通横屏模式
 1 : 手机直播模式
 */
@property (nonatomic, copy) NSString *broadcast_type;

@end


































