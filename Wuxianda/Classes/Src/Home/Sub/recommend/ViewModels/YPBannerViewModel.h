//
//  YPBannerViewModel.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/5/31.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  轮播图VM

#import <Foundation/Foundation.h>
#import "YPBannerModel.h"

@interface YPBannerViewModel : NSObject

#pragma mark - Model
@property (nonatomic, strong) YPBannerModel *model;

#pragma mark - init
/** 初始化方法 */
- (instancetype)initWithModel:(YPBannerModel *)model;

#pragma mark - 网络请求相关
/** 请求命令 */
@property (nonatomic, strong, readonly) RACCommand *requestCommand;

/** 从网络中加载启动页数据 */
- (void)loadDataArrFromNetwork;

#pragma mark - 业务逻辑相关
@property (nonatomic, weak) UIViewController *targetController;

@end
