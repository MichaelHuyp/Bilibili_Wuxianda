//
//  YPNetManager.h
//  Wuxianda
//
//  Created by 胡云鹏 on 16/5/21.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  基于AFHTTPSession的单例类

#import <AFNetworking/AFNetworking.h>

@interface YPNetManager : AFHTTPSessionManager

/**
 *  单例
 */
+ (instancetype)shareManager;

@end
