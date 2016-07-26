//
//  YPReplyContentViewModel.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/17.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPReplyContentViewModel.h"

@implementation YPReplyContentViewModel

#pragma mark - Public
/** 初始化方法 */
- (instancetype)initWithModel:(YPReplyContentModel *)model
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
            
#if 1
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"_device"] = @"iphone";
            params[@"_hwid"] = @"d5cedfe69595d79f";
            params[@"_ulv"] = @"0";
            params[@"access_key"] = @"";
            params[@"appkey"] = @"27eb53fc9058f8c3";
            params[@"appver"] = @"3390";
            params[@"build"] = @"3390";
            params[@"nohot"] = @"1";
            params[@"oid"] = _oid;
            params[@"platform"] = @"ios";
            params[@"pn"] = @"1";
            params[@"ps"] = @"10";
            params[@"sign"] = @"371a2133eb5787a8cc57a01a8ef0dbe3";
            params[@"sort"] = @"2";
            params[@"type"] = @"1";
            

            @weakify(self);
            [YPRequestTool GET:kReplyContentURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                @strongify(self);
                
//                self.model = [YPReplyContentModel mj_objectWithKeyValues:responseObject[@"data"]];
                self.model = [YPReplyContentModel modelWithJSON:responseObject[@"data"]];
                
                [subscriber sendNext:self.model];
                
                [subscriber sendCompleted];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
#endif
           
#warning 这个接口没有加密 []~(￣▽￣)~*
#if 0
            NSData *data = [NSData dataNamed:@"bangumi_detail_reply.json"];
            id responseObject = [data jsonValueDecoded];
            self.model = [YPReplyContentModel modelWithJSON:responseObject[@"data"]];
            [subscriber sendNext:self.model];
            [subscriber sendCompleted];
#endif
            
            return nil;
        }];
        
        return signal;
    }];
}

@end
