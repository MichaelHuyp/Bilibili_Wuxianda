//
//  YPLaunchViewModel.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/5/31.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YPLaunchModel.h"

@interface YPLaunchViewModel : NSObject

/** 模型 */
@property (nonatomic, strong) YPLaunchModel *model;

/** 请求命令 */
@property (nonatomic, strong, readonly) RACCommand *requestCommand;

/** 从网络中加载启动页数据 */
- (void)loadLaunchDataArrFromNetwork;

/** 初始化方法 */
- (instancetype)initWithModel:(YPLaunchModel *)model;

/** 是否符合当前时间戳 */
- (BOOL)conformsNowtimestamp;

@end

