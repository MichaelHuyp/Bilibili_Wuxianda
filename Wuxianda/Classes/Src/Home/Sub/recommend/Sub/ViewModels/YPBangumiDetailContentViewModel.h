//
//  YPBangumiDetailContentViewModel.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/17.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  番剧详情内容VM

#import <Foundation/Foundation.h>
#import "YPBangumiDetailContentModel.h"

@interface YPBangumiDetailContentViewModel : NSObject

#pragma mark - Model
@property (nonatomic, strong) YPBangumiDetailContentModel *model;

#pragma mark - init
/** 初始化方法 */
- (instancetype)initWithModel:(YPBangumiDetailContentModel *)model;

#pragma mark - 网络请求相关
/** 请求命令 */
@property (nonatomic, strong, readonly) RACCommand *requestCommand;

/** 从网络中加载启动页数据 */
- (void)loadDataArrFromNetwork;

#pragma mark - 业务逻辑相关
@property (nonatomic, copy) NSString *season_id;

@end
