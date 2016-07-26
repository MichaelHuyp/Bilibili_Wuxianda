//
//  YPRealPartitionModel.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/11.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  分区数据模型

#import <Foundation/Foundation.h>
#import "YPRealPartitionSubIconModel.h"

@interface YPRealPartitionModel : NSObject

/** id */
@property (nonatomic, copy) NSString *idStr;

/** 名字 */
@property (nonatomic, copy) NSString *name;

/** 分类 */
@property (nonatomic, copy) NSString *area;

/** 分区直播数 */
@property (nonatomic, copy) NSString *count;

/** 图片模型 */
@property (nonatomic, strong) YPRealPartitionSubIconModel *sub_icon;

@end
