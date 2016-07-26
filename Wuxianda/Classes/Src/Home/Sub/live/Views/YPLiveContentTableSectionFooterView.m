//
//  YPLiveContentTableSectionFooterView.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/13.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPLiveContentTableSectionFooterView.h"
#import "YPRefreshTypeButton.h"

@interface YPLiveContentTableSectionFooterView ()

/** 查看更多按钮 */
@property (weak, nonatomic) IBOutlet UIButton *seeMoreBtn;

/** 刷新按钮 */
@property (weak, nonatomic) IBOutlet YPRefreshTypeButton *refreshBtn;

@property (nonatomic, copy) YPLiveContentTableSectionFooterViewCallBack seeMoreCallBack;
@property (nonatomic, copy) YPLiveContentTableSectionFooterViewCallBack refreshCallBack;

@end

@implementation YPLiveContentTableSectionFooterView

#pragma mark - Public
+ (instancetype)liveContentTableSectionFooterViewWithSeeMoreCallBack:(YPLiveContentTableSectionFooterViewCallBack)seeMoreCallBack refreshCallBack:(YPLiveContentTableSectionFooterViewCallBack)refreshCallBack
{
    YPLiveContentTableSectionFooterView *view = [YPLiveContentTableSectionFooterView viewFromXib];
    view.seeMoreCallBack = seeMoreCallBack;
    view.refreshCallBack = refreshCallBack;
    return view;
}

#pragma mark - Override

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // self
    self.autoresizingMask = UIViewAutoresizingNone;
    self.backgroundColor = YPMainBgColor;
    
    // 查看更多按钮
    @weakify(self);
    [[_seeMoreBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.seeMoreCallBack) {
            self.seeMoreCallBack();
        }
    }];
    
    // 刷新按钮
    [[_refreshBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.refreshCallBack) {
            self.refreshCallBack();
        }
    }];
    
}

@end































