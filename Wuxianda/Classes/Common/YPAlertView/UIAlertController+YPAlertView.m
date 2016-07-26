//
//  UIAlertController+YPAlertView.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/2.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "UIAlertController+YPAlertView.h"
#import <objc/runtime.h>

@interface UIAlertController (YPAlertViewPrivate)

@property (nonatomic, strong) UIWindow *alertWindow;

@end

@implementation UIAlertController (YPAlertViewPrivate)

@dynamic alertWindow;

- (void)setAlertWindow:(UIWindow *)alertWindow {
    objc_setAssociatedObject(self, @selector(alertWindow), alertWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIWindow *)alertWindow {
    return objc_getAssociatedObject(self, @selector(alertWindow));
}

- (void)show {
    [self show:YES];
}

- (void)show:(BOOL)animated {
    self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.alertWindow.rootViewController = [[UIViewController alloc] init];
    
    // we inherit the main window's tintColor
    self.alertWindow.tintColor = [UIApplication sharedApplication].delegate.window.tintColor;
    // window level is above the top window (this makes the alert, if it's a sheet, show over the keyboard)
    UIWindow *topWindow = [UIApplication sharedApplication].windows.lastObject;
    self.alertWindow.windowLevel = topWindow.windowLevel + 1;
    
    [self.alertWindow makeKeyAndVisible];
    [self.alertWindow.rootViewController presentViewController:self animated:animated completion:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // precaution to insure window gets destroyed
    self.alertWindow.hidden = YES;
    self.alertWindow = nil;
}


@end
