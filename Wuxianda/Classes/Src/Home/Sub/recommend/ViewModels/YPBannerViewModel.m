//
//  YPBannerViewModel.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/5/31.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPBannerViewModel.h"
#import "YPBilibiliWebViewController.h"
#import "YPBangumiDetailViewController.h"

@implementation YPBannerViewModel

#pragma mark - Public
/** 初始化方法 */
- (instancetype)initWithModel:(YPBannerModel *)model
{
    self = [super init];
    if (!self) return nil;
    self.model = model;
    return self;
}

/** 从网络中加载轮播图数据 */
- (void)loadDataArrFromNetwork
{
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"build"] = @"3360";
            params[@"channel"] = @"appstore";
            params[@"plat"] = @"2";
            
            // kBannerURL
            [YPRequestTool GET:kBannerURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
//                NSArray *modelArray = [YPBannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                NSArray *modelArray = [NSArray modelArrayWithClass:[YPBannerModel class] json:responseObject[@"data"]];
                
                [subscriber sendNext:modelArray];
                
                [subscriber sendCompleted];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [subscriber sendError:error];
            }];
            
            return nil;
        }];
        
        return signal;
    }];
}

- (UIViewController *)targetController
{
    UIViewController *defaultController = [UIViewController controller];
    
    if ([self.model.type isEqualToString:@"2"]) { // 网页跳转
        YPBilibiliWebViewController *vc = [YPBilibiliWebViewController controller];
        vc.model = self.model;
        return vc;
    } else if ([self.model.type isEqualToString:@"3"]) {
        YPBangumiDetailViewController *vc = [YPBangumiDetailViewController controller];
        vc.season_id = self.model.value;
        return vc;
    }
    
    return defaultController;
}

@end
