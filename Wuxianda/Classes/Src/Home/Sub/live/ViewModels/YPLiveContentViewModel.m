//
//  YPLiveContentViewModel.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/11.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPLiveContentViewModel.h"

@implementation YPLiveContentViewModel

#pragma mark - Public
- (instancetype)initWithModel:(YPLiveContentModel *)model
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
            NSData *data = [NSData dataNamed:@"live_content.json"];
            id responseObject = [data jsonValueDecoded];
            self.model = [YPLiveContentModel modelWithJSON:responseObject[@"data"]];
            [subscriber sendNext:self.model];
            [subscriber sendCompleted];
#endif
            
            /**
             *  http://live.bilibili.com/api/playurl?player=1&quality=0&cid=room_id
             */
            
            
            [YPRequestTool GET:@"http://live.bilibili.com/AppIndex/home?_device=android&_hwid=51e96f5f2f54d5f9&_ulv=10000&access_key=563d6046f06289cbdcb472601ce5a761&appkey=c1b107428d337928&build=410000&platform=android&scale=xxhdpi&sign=fbdcfe141853f7e2c84c4d401f6a8758" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                self.model = [YPLiveContentModel modelWithJSON:responseObject[@"data"]];
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
