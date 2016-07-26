//
//  YPLivePartitionModel.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/11.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  直播模块分区数据模型(分区模型 + 直播模型)

#import <Foundation/Foundation.h>
#import "YPRealPartitionModel.h"

@interface YPLivePartitionModel : NSObject

/** 分区数据模型 */
@property (nonatomic, strong) YPRealPartitionModel *partition;

/** 直播数据源模型 */
@property (nonatomic, copy) NSArray *lives;

@end
