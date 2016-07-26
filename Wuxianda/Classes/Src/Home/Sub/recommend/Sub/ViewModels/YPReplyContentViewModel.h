//
//  YPReplyContentViewModel.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/17.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  回复内容VM

#import <Foundation/Foundation.h>
#import "YPReplyContentModel.h"

@interface YPReplyContentViewModel : NSObject

#pragma mark - Model
@property (nonatomic, strong) YPReplyContentModel *model;

#pragma mark - init
/** 初始化方法 */
- (instancetype)initWithModel:(YPReplyContentModel *)model;

#pragma mark - 网络请求相关
/** 请求命令 */
@property (nonatomic, strong, readonly) RACCommand *requestCommand;

/** 从网络中加载启动页数据 */
- (void)loadDataArrFromNetwork;

#pragma mark - 业务逻辑相关
@property (nonatomic, copy) NSString *oid;

@end
