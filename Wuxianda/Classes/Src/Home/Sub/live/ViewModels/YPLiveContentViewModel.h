//
//  YPLiveContentViewModel.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/11.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  直播内容VM

#import <Foundation/Foundation.h>
#import "YPLiveContentModel.h"

@interface YPLiveContentViewModel : NSObject

#pragma mark - Model
@property (nonatomic, strong) YPLiveContentModel *model;

#pragma mark - init
/** 初始化方法 */
- (instancetype)initWithModel:(YPLiveContentModel *)model;

#pragma mark - 网络请求相关
/** 请求命令 */
@property (nonatomic, strong, readonly) RACCommand *requestCommand;

/** 从网络中加载启动页数据 */
- (void)loadDataArrFromNetwork;

@end
