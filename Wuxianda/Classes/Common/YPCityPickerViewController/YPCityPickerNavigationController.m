//
//  YPCityPickerNavigationController.m
//  Wuxianda
//
//  Created by 胡云鹏 on 16/7/2.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPCityPickerNavigationController.h"

@interface YPCityPickerNavigationController ()

@end

@implementation YPCityPickerNavigationController

+ (void)initialize
{
    // 当导航栏用在YPNavigationController中appearance才会生效
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:[self class], nil];
    [bar setTintColor:YPWhiteColor];
    [bar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.37 green:0.60 blue:0.03 alpha:1.00]] forBarMetrics:UIBarMetricsDefault];
    NSMutableDictionary *titleAttrs = [NSMutableDictionary dictionary];
    titleAttrs[NSForegroundColorAttributeName] = YPWhiteColor;
    titleAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [bar setTitleTextAttributes:titleAttrs];
}

@end
