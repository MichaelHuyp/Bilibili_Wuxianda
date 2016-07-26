//
//  YPBangumiContentViewModel.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/20.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPBangumiContentViewModel.h"

@implementation YPBangumiContentViewModel

#pragma mark - Public
- (instancetype)initWithModel:(YPBangumiContentModel *)model
{
    self = [super init];
    if (!self) return nil;
    self.model = model;
    return self;
}


/** 从网络中加载启动页数据 */
- (void)loadDataArrFromNetwork
{
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [YPRequestTool GET:@"http://bangumi.bilibili.com/api/bangumi_recommend?actionKey=appkey&appkey=27eb53fc9058f8c3&build=3440&cursor=0&device=phone&mobi_app=iphone&pagesize=10&platform=ios&sign=51fb8d793fa26c9b12e2b73311bcf95a&ts=1468980621" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                self.modelArr = [NSArray modelArrayWithClass:[YPBangumiContentModel class] json:responseObject[@"result"]];
                
                [subscriber sendNext:self.modelArr];
                [subscriber sendCompleted];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [subscriber sendError:error];
            }];
            
            return nil;
        }];
        
        return signal;
    }];
}

@end
