//
//  YPAlertView.h
//  YPAlertView
//
//  Created by 胡云鹏 on 15/11/10.
//  Copyright (c) 2015年 tyiti. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 按钮点击触发的回调 */
typedef void(^YPAlertViewBlock)(NSInteger buttonIndex);

@interface YPAlertView : UIView

/**
 *  总方法
 */
+ (void)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles andAction:(YPAlertViewBlock) block andParentView:(UIView *)view;

@end
