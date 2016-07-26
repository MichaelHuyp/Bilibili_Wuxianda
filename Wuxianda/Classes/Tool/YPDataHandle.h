//
//  YPDataHandle.h
//  xinfenbao
//
//  Created by MichaelPPP on 15/11/15.
//  Copyright (c) 2015年 tianyuanwangluo. All rights reserved.
//  单例

#import <Foundation/Foundation.h>

@interface YPDataHandle : NSObject

@property (nonatomic, assign) BOOL isFromVideoLaunchVc;

+ (instancetype)shareHandle;

@end
