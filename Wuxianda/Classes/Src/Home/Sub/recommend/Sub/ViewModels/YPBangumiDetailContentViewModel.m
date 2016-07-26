//
//  YPBangumiDetailContentViewModel.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/17.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPBangumiDetailContentViewModel.h"

@implementation YPBangumiDetailContentViewModel

#pragma mark - Public
/** 初始化方法 */
- (instancetype)initWithModel:(YPBangumiDetailContentModel *)model
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
            
            
#if 0
#warning 加密了啊 ！！！！！ 暂时换成json死数据。。。
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"actionKey"] = @"appkey";
            params[@"appkey"] = @"27eb53fc9058f8c3";
            params[@"build"] = @"3390";
            params[@"device"] = @"phone";
            params[@"mobi_app"] = @"iphone";
            params[@"platform"] = @"ios";
            params[@"season_id"] = _season_id;
            params[@"sign"] = @"9ed1dae7dcb244469b0c1732d04658a8";
            params[@"ts"] = @"1467017833";
            params[@"type"] = @"bangumi";
            
            @weakify(self);
            [YPRequestTool GET:kBangumiDetailContentURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                @strongify(self);
                
//                self.model = [YPBangumiDetailContentModel mj_objectWithKeyValues:responseObject[@"result"]];
                self.model = [YPBangumiDetailContentModel modelWithJSON:responseObject[@"result"]];
                
                [subscriber sendNext:self.model];
                
                [subscriber sendCompleted];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            }];
#endif
            
            NSData *data = [NSData dataNamed:@"bangumi_detail_season.json"];
            id responseObject = [data jsonValueDecoded];
            self.model = [YPBangumiDetailContentModel modelWithJSON:responseObject[@"result"]];
            [subscriber sendNext:self.model];
            [subscriber sendCompleted];
            
            
            return nil;
        }];
        
        return signal;
    }];
}

@end
