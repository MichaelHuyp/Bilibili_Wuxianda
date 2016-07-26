//
//  YPCityPickerViewController.h
//  YPCityPickerViewController
//
//  Created by MichaelPPP on 16/7/1.
//  Copyright © 2016年 MichaelHuyp. All rights reserved.
//  城市选择控制器

#import <UIKit/UIKit.h>

@class YPCityPickerViewController;

typedef void(^YPCityPickerViewControllerCallBack)(NSString *selectCityName);

@interface YPCityPickerViewController : UIViewController

+ (instancetype)cityPickerViewControllerWithCallBack:(YPCityPickerViewControllerCallBack)callBack;

/** 城市数组 */
@property (nonatomic, copy) NSArray *citys;

/** 热门城市名字数组 */
@property (nonatomic, copy) NSArray *hotCitys;

/** 当前城市名字 */
@property (nonatomic, copy) NSString *currentCityName;

@end
