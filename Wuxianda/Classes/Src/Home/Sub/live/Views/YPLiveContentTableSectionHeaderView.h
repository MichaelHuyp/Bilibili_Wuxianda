//
//  YPLiveContentTableSectionHeaderView.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/13.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YPRealPartitionModel;

typedef void(^YPLiveContentTableSectionHeaderViewCallBack)(void);

@interface YPLiveContentTableSectionHeaderView : UIView

@property (nonatomic, strong) YPRealPartitionModel *model;

+ (instancetype)liveContentTableSectionHeaderViewWithDidTouchCallBack:(YPLiveContentTableSectionHeaderViewCallBack)callBack;

@end
