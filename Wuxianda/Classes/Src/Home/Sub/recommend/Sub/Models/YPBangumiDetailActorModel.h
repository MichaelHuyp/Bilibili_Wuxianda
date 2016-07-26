//
//  YPBangumiDetailActorModel.h
//  Wuxianda
//
//  Created by 胡云鹏 on 16/6/18.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  番剧详情演员模型

#import <Foundation/Foundation.h>

@interface YPBangumiDetailActorModel : NSObject

/** 演员名字 */
@property (nonatomic, copy) NSString *actor;
/** 演员id */
@property (nonatomic, copy) NSString *actor_id;
/** 角色名字 */
@property (nonatomic, copy) NSString *role;

@end

/**
 {
 "actor":"酒井广大",
 "actor_id":0,
 "role":"光宗"
 }
 */