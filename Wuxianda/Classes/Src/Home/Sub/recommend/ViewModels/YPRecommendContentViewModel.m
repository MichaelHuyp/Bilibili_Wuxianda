//
//  YPRecommendContentViewModel.m
//  Wuxianda
//
//  Created by 胡云鹏 on 16/6/9.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPRecommendContentViewModel.h"
// header
#import "YPHotRecommendHeaderView.h"
#import "YPLiveHeaderView.h"
#import "YPTopicHeaderView.h"
#import "YPAVHeaderView.h"
#import "YPRegionHeaderView.h"
// footer
#import "YPHotRecommendFooterView.h"
#import "YPBangumiFooterView.h"
#import "YPRegionFooterView.h"


@implementation YPRecommendContentViewModel
{
    CGFloat _footerSectionHeight;
    CGFloat _headerSectionHeight;
    CGFloat _cellHeight;
}

#pragma mark - Public
/** 初始化方法 */
- (instancetype)initWithModel:(YPRecommendContentModel *)model
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
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"build"] = @"3390";
            params[@"channel"] = @"appstore";
            params[@"plat"] = @"1";
            params[@"actionKey"] = @"appkey";
            params[@"appkey"] = @"27eb53fc9058f8c3";
            params[@"device"] = @"phone";
            params[@"platform"] = @"ios";
            params[@"sign"] = @"dc5d0dd8e3ff190042473a332f435a03";
            params[@"ts"] = @"1465476506";
            
            // kRecommendContentURL
            [YPRequestTool GET:kRecommendContentURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                
//                NSArray *modelArray = [YPRecommendContentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                NSArray *modelArray = [NSArray modelArrayWithClass:[YPRecommendContentModel class] json:responseObject[@"data"]];
                
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

- (UITableViewCell *)cellWithTableView:(UITableView *)tableView
{
    UITableViewCell *normalcell = [[UITableViewCell alloc] init];
    
    if ([self.model.style isEqualToString:@"medium"]) {
        YPRecommendContentCommonStyleCell *cell = [tableView dequeueReusableCellWithIdentifier:CommonStyleCellID];
        cell.vm = self;
        return cell;
    } else if ([self.model.style isEqualToString:@"large"]) {
        YPRecommendContentLargeStyleCell *cell = [tableView dequeueReusableCellWithIdentifier:LargeStyleCellID];
        cell.vm = self;
        return cell;
    } else if ([self.model.style isEqualToString:@"small"]) {
        YPRecommendContentSmallStyleCell *cell = [tableView dequeueReusableCellWithIdentifier:SmallStyleCellID];
        cell.vm = self;
        return cell;
    }
    return normalcell;
}

#pragma mark - Getter

- (CGFloat)footerSectionHeight
{
    if (!_footerSectionHeight) {
        if ([self.model.type isEqualToString:@"recommend"]) {
            _footerSectionHeight = 64.0f;
        } else if ([self.model.type isEqualToString:@"bangumi"]) {
            _footerSectionHeight = 64.0f;
        } else if ([self.model.type isEqualToString:@"region"] || [self.model.type isEqualToString:@"live"]) {
            _footerSectionHeight = 64.0f;
        } else if ([self.model.type isEqualToString:@"topic"]) {
            _footerSectionHeight = 20.0f;
        } else if ([self.model.type isEqualToString:@"av"]) {
            _footerSectionHeight = 10.0f;
        }
    }
    return _footerSectionHeight;
}

- (CGFloat)headerSectionHeight
{
    if (!_headerSectionHeight) {
        if ([self.model.type isEqualToString:@"recommend"]) {
            _headerSectionHeight = 53.0f;
        } else if ([self.model.type isEqualToString:@"live"]) {
            _headerSectionHeight = 53.0f;
        } else if ([self.model.type isEqualToString:@"topic"]) {
            _headerSectionHeight = 53.0f;
        } else if ([self.model.type isEqualToString:@"av"]) {
            _headerSectionHeight = 10.0f;
        } else if ([self.model.type isEqualToString:@"bangumi"]) {
            _headerSectionHeight = 53.0f;
        } else if ([self.model.type isEqualToString:@"region"] || [self.model.type isEqualToString:@"sp"]) {
            _headerSectionHeight = 53.0f;
        }
    }
    return _headerSectionHeight;
}

- (CGFloat)cellHeight
{
    if (!_cellHeight) {
        if ([self.model.style isEqualToString:@"medium"]) {
            _cellHeight = 348;
        } else if ([self.model.style isEqualToString:@"large"]) {
            _cellHeight = 120;
        } else if ([self.model.style isEqualToString:@"small"]) {
            _cellHeight = 250;
        }
    }
    return _cellHeight;
}

- (UIView *)headerSectionView
{
    UIView *defaultUIView = [UIView new];
    defaultUIView.backgroundColor = YPWhiteColor;
    
    if ([self.model.type isEqualToString:@"recommend"]) {
        YPHotRecommendHeaderView *view = [YPHotRecommendHeaderView viewFromXib];
        return view;
    } else if ([self.model.type isEqualToString:@"live"]) {
        YPLiveHeaderView *view = [YPLiveHeaderView viewFromXib];
        return view;
    } else if ([self.model.type isEqualToString:@"topic"]) {
        YPTopicHeaderView *view = [YPTopicHeaderView viewFromXib];
        return view;
    } else if ([self.model.type isEqualToString:@"av"]) {
        YPAVHeaderView *view = [YPAVHeaderView viewFromXib];
        return view;
    } else if ([self.model.type isEqualToString:@"bangumi"]) {
        YPRegionHeaderView *view = [YPRegionHeaderView regionHeaderViewWithTitle:@"番剧推荐" icon:[UIImage imageNamed:@"home_subregion_bangumi"] detailContent:@"查看所有番剧"];
        return view;
    } else if ([self.model.type isEqualToString:@"region"] || [self.model.type isEqualToString:@"sp"]) {
        NSString *imageName = [NSString stringWithFormat:@"home_region_icon_%@",self.model.param];
        YPRegionHeaderView *view = [YPRegionHeaderView regionHeaderViewWithTitle:self.model.title icon:[UIImage imageNamed:imageName] detailContent:nil];
        return view;
    }
    
    return defaultUIView;
}

- (UIView *)footerSectionView
{
    UIView *defaultUIView = [UIView new];
    defaultUIView.backgroundColor = YPWhiteColor;
    
    if ([self.model.type isEqualToString:@"recommend"]) {
        YPHotRecommendFooterView *view = [YPHotRecommendFooterView hotRecommendFooterView];
        return view;
    } else if ([self.model.type isEqualToString:@"bangumi"]) {
        YPBangumiFooterView *view = [YPBangumiFooterView viewFromXib];
        return view;
    } else if ([self.model.type isEqualToString:@"region"] || [self.model.type isEqualToString:@"live"]) {
        YPRegionFooterView *view = [YPRegionFooterView viewFromXib];
        return view;
    }
    
    return defaultUIView;
}

@end
