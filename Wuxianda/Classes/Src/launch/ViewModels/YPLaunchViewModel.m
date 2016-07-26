//
//  YPLaunchViewModel.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/5/31.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPLaunchViewModel.h"

@interface YPLaunchViewModel ()


@end

@implementation YPLaunchViewModel

#pragma mark - Public
- (instancetype)initWithModel:(YPLaunchModel *)model
{
    self = [super init];
    if (!self) return nil;
    self.model = model;
    return self;
}

- (BOOL)conformsNowtimestamp
{
    long long timestamp = (long long)[[NSDate date] timeIntervalSince1970];
    
    if (timestamp > [self.model.start_time longLongValue] && timestamp < [self.model.end_time longLongValue]) {
        return YES;
    }
    return NO;
}

/** 从网络中加载启动页数据 */
- (void)loadLaunchDataArrFromNetwork
{
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"build"] = @"3360";
            params[@"channel"] = @"appstore";
            params[@"plat"] = @"1";
            params[@"width"] = [@((int)YPScreenW * 2) stringValue];
            params[@"height"] = [@((int)YPScreenH * 2) stringValue];
            
            YPLog(@"%f, %f",YPScreenW,YPScreenH);
            
            [YPRequestTool GET:kSplashURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                
                // 程序的入口 开启计数器
                NSString *appOpenTimesStr = [YPUserDefaults objectForKey:kAppLaunchTimes];
                if (![appOpenTimesStr isNotBlank]) { // 如果开启次数字段没有值
                    NSInteger appOpenTimes = 1;
                    [YPUserDefaults setValue:[NSString stringWithFormat:@"%ld",appOpenTimes] forKey:kAppLaunchTimes];
                }
                
                // 数据处理 并返回
//                NSArray *modelArray = [YPLaunchModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                NSArray *modelArray = [NSArray modelArrayWithClass:[YPLaunchModel class] json:responseObject[@"data"]];
                
                [subscriber sendNext:modelArray];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                YPLog(@"%@",error);
            }];
            
            return nil;
        }];
        
        return signal;
    }];
}






@end








































