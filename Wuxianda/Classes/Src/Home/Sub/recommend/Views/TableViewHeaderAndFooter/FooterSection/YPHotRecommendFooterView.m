//
//  YPHotRecommendFooterView.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/14.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPHotRecommendFooterView.h"
#import "YPRefreshButton.h"

@interface YPHotRecommendFooterView ()


@end

@implementation YPHotRecommendFooterView

+ (instancetype)hotRecommendFooterView
{
    YPHotRecommendFooterView *view = [YPHotRecommendFooterView viewFromXib];
    
    YPRefreshButton *refreshBtn = [YPRefreshButton viewFromXib];
    [view addSubview:refreshBtn];
    
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(refreshBtn.superview.mas_left).with.offset(64);
        make.right.equalTo(refreshBtn.superview.mas_right).with.offset(-64);
        make.centerY.equalTo(refreshBtn.superview.mas_centerY).with.offset(0);
        make.height.mas_equalTo(36);
    }];
    
    return view;
}

@end
