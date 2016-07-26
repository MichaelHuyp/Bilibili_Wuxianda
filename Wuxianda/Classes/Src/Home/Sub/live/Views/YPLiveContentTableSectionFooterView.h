//
//  YPLiveContentTableSectionFooterView.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/13.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YPLiveContentTableSectionFooterViewCallBack)(void);

@interface YPLiveContentTableSectionFooterView : UIView

+ (instancetype)liveContentTableSectionFooterViewWithSeeMoreCallBack:(YPLiveContentTableSectionFooterViewCallBack)seeMoreCallBack refreshCallBack:(YPLiveContentTableSectionFooterViewCallBack)refreshCallBack;

@end
