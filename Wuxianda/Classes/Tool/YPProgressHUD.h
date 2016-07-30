//
//  YPProgressHUD.h
//  Wuxianda
//
//  Created by 胡云鹏 on 16/5/21.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  HUD工具类

#import <Foundation/Foundation.h>

@interface YPProgressHUD : NSObject

+ (void)show;

+ (void)showWithMessage:(NSString *)message;

+ (void)dismiss;

+ (void)showError:(NSString *)errorInfo;

+ (void)showSuccess:(NSString *)info;

@end
