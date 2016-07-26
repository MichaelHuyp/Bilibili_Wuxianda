//
//  UIViewController+YPInit.h
//  YPExtension
//
//  Created by 胡云鹏 on 15/8/21.
//  Copyright (c) 2015年 MichaelPPP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (YPInit)

+ (instancetype)controller;

- (UIView *)createBackNormalWithTitle:(NSString *)title;

@end
