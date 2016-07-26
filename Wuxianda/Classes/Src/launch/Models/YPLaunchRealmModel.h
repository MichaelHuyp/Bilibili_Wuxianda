//
//  YPLaunchRealmModel.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/5/31.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import <Realm/Realm.h>
@class YPLaunchModel;

@interface YPLaunchRealmModel : RLMObject
/** 启动页的结束时间戳 */
@property NSString *end_time;
/** 启动页的开始时间戳 */
@property NSString *start_time;
/** 启动页持续的时间 */
@property NSString *duration;
/** 启动页图片地址 */
@property NSString *image;
/** 启动页的出现次数 */
@property NSString *times;

/** 初始化方法 */
- (instancetype)initWithModel:(YPLaunchModel *)model;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<YPLaunchRealmModel>
RLM_ARRAY_TYPE(YPLaunchRealmModel)
