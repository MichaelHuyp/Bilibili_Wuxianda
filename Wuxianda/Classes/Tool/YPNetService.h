//
//  YPNetService.h
//  xinfenbao
//
//  Created by MichaelPPP on 15/12/14.
//  Copyright (c) 2015年 tianyuanwangluo. All rights reserved.
//  网络服务类

#import <Foundation/Foundation.h>

@interface YPNetService : NSObject

+ (instancetype)shareInstance;

/**
 *  判断是否为代理服务器
 */
- (BOOL)isProtocolService;

@end
