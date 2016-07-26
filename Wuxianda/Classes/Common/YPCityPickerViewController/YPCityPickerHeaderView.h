//
//  YPCityPickerHeaderView.h
//  YPCityPickerViewController
//
//  Created by MichaelPPP on 16/7/1.
//  Copyright © 2016年 MichaelHuyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YPCityPickerHeaderView;

typedef void(^YPCityPickerHeaderViewCallBack)(NSString *selectCityName);

@interface YPCityPickerHeaderView : UIView

+ (instancetype)cityPickerHeaderViewWithCallBack:(YPCityPickerHeaderViewCallBack)callBack;

/** 当前城市名字 */
@property (nonatomic, copy) NSString *currentCityName;

/** 热门城市名字数组 */
@property (nonatomic, copy) NSArray *hotCityNames;

/** 记录城市选择头部视图的高度 */
@property (nonatomic, assign) CGFloat viewH;

@end
