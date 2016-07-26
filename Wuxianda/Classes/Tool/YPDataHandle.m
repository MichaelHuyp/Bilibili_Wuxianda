//
//  YPDataHandle.m
//  xinfenbao
//
//  Created by MichaelPPP on 15/11/15.
//  Copyright (c) 2015年 tianyuanwangluo. All rights reserved.
//

#import "YPDataHandle.h"

@implementation YPDataHandle

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

+ (instancetype)shareHandle
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

@end
