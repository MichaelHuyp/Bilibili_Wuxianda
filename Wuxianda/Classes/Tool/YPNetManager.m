//
//  YPNetManager.m
//  Wuxianda
//
//  Created by 胡云鹏 on 16/5/21.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPNetManager.h"

@implementation YPNetManager

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain",@"text/html", nil];
    return self;
}

#pragma mark - Public
+ (instancetype)shareManager
{
    static YPNetManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}



@end
