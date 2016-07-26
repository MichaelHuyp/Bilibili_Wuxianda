//
//  YPBangumiHeaderContentViewModel.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/20.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPBangumiHeaderContentViewModel.h"

@implementation YPBangumiHeaderContentViewModel

#pragma mark - Public
- (instancetype)initWithModel:(YPBangumiHeaderContentModel *)model
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
            
            [YPRequestTool GET:@"http://bangumi.bilibili.com/api/app_index_page_v3?actionKey=appkey&appkey=27eb53fc9058f8c3&build=3440&device=phone&mobi_app=iphone&platform=ios&sign=c647c543b614dc848d3ad88dfd8cdea8&ts=1468980621" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                self.model = [YPBangumiHeaderContentModel modelWithJSON:responseObject[@"result"]];
                [subscriber sendNext:self.model];
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
