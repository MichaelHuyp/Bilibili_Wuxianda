//
//  YPRuntimeHelper.h
//  xinfenbao
//
//  Created by MichaelPPP on 15/12/22.
//  Copyright (c) 2015年 tianyuanwangluo. All rights reserved.
//  运行时帮助类

#import <Foundation/Foundation.h>

@interface YPRuntimeHelper : NSObject

+ (instancetype)shareInstance;

/**
 *  提取对象的全部属性名
 */
- (NSArray*)extractPropertyNamesFromOjbect:(NSObject*)object;

/**
 *  提取对象的指定类名的全部属性值
 */
- (NSArray*)extractValuesFromObject:(NSObject*)object forPropertiesWithClass:(NSString*)className;

/**
 *  提取对象的指定协议的全部属性值
 */
- (NSArray*)extractValuesFromObject:(NSObject*)object forPropertiesWithProtocol:(NSString*)protocolName;

@end
