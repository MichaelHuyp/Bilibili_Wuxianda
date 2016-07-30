//
//  YPProgressHUD.m
//  Wuxianda
//
//  Created by 胡云鹏 on 16/5/21.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPProgressHUD.h"
#import "SVProgressHUD.h"

@implementation YPProgressHUD



+ (void)show
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD show];
}

+ (void)showWithMessage:(NSString *)message
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD showWithStatus:message];
}

+ (void)dismiss
{
    [SVProgressHUD dismiss];
}

+ (void)showError:(NSString *)errorInfo
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    
    [SVProgressHUD setMinimumDismissTimeInterval:0.1f];
    [SVProgressHUD showErrorWithStatus:errorInfo];
}

+ (void)showSuccess:(NSString *)info
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    
    [SVProgressHUD setMinimumDismissTimeInterval:0.1f];
    [SVProgressHUD showSuccessWithStatus:info];
}

@end
