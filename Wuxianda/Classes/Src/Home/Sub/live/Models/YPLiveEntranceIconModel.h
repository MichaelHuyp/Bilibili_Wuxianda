//
//  YPLiveEntranceIconModel.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/11.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  直播模块入口数据模型

#import <Foundation/Foundation.h>
#import "YPRealEntranceIconModel.h"

@interface YPLiveEntranceIconModel : NSObject

/** id */
@property (nonatomic, copy) NSString *idStr;

/** 名字 */
@property (nonatomic, copy) NSString *name;

/** 图标对象 */
@property (nonatomic, strong) YPRealEntranceIconModel *entrance_icon;

@end
