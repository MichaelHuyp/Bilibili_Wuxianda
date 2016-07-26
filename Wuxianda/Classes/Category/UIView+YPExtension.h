//
//  UIView+YPExtension.h
//  YPExtension
//
//  Created by 胡云鹏 on 15/8/18.
//  Copyright (c) 2015年 MichaelPPP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YPExtension)

/**
 * 判断一个控件是否真正显示在主窗口
 */
- (BOOL)isShowingOnKeyWindow;

/**
 *  从xib加载
 */
+ (instancetype)viewFromXib;

@end
