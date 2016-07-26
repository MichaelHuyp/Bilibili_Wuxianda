//
//  YPAlertView.m
//  YPAlertView
//
//  Created by 胡云鹏 on 15/11/10.
//  Copyright (c) 2015年 tyiti. All rights reserved.
//

#import "YPAlertView.h"

static inline BOOL versionBigger9()
{
    float sysVersion = [[UIDevice currentDevice].systemVersion floatValue];
    
    if (sysVersion >= 9.0) {
        return YES;
    } else {
        return NO;
    }
}

@interface UIView (YPSearchVcExtend)

- (UIViewController *)viewController;

@end

@implementation UIView (YPSearchVcExtend)

- (UIViewController*)viewController {
    for (UIView* next = self; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
@end


@interface YPAlertView () <UIAlertViewDelegate>

/** 按钮点击触发的回调 */
@property (nonatomic, copy) YPAlertViewBlock block;

@end

@implementation YPAlertView

#pragma mark - Life Cycle -
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
        
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.1];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    self.frame = newSuperview.bounds;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - 私有方法 -
- (void)showWithTitle:(NSString *)title andMessage:(NSString *)message andCancelButtonTitle:(NSString *)cancelButtonTitle andOtherButtonTitles:(NSArray *)otherButtonTitles;
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    
    for (NSString *otherTitle in otherButtonTitles) {
        [alertView addButtonWithTitle:otherTitle];
    }
    
    [alertView show];
}


#pragma mark - 公有方法 -

+ (void)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles andAction:(YPAlertViewBlock) block andParentView:(UIView *)view
{
    if (versionBigger9()) { // IOS 9以上
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
        __block YPAlertView *alert = [[YPAlertView alloc] init];
        alert.block = block;
        
        if (cancelButtonTitle) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                if (alert.block) {
                    alert.block(0);
                }
                
            }];
            [alertVc addAction:action];
        }
    
        for (int i=0; i < otherButtonTitles.count; i++) {
            NSString *otherTitle = otherButtonTitles[i];
            UIAlertAction *action = [UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                if (cancelButtonTitle) {
                    if (alert.block) {
                        alert.block(i+1);
                    }
                } else {
                    if (alert.block) {
                        alert.block(i);
                    }
                }
            }];
            [alertVc addAction:action];
        }
        
        if (view == nil) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window.rootViewController presentViewController:alertVc animated:YES completion:nil];
        } else {
            [[view viewController] presentViewController:alertVc animated:YES completion:nil];
        }
    } else { // IOS 9以下
        if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
        
        YPAlertView *alert = [[YPAlertView alloc] init];
        [alert showWithTitle:title andMessage:message andCancelButtonTitle:cancelButtonTitle andOtherButtonTitles:otherButtonTitles];
        alert.block = block;
        [view addSubview:alert];
    }

}

#pragma mark - UIAlertViewDelegate -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 回调
    if (self.block) {
        self.block(buttonIndex);
    }
    
    // 点击事件完成需要将视图移除
    [self removeFromSuperview];
}





@end
