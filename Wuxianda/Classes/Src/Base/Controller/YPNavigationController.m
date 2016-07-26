//
//  YPNavigationController.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/1/21.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPNavigationController.h"

@interface YPNavigationController ()

@end

@implementation YPNavigationController

#pragma mark - 屏幕旋转控制方法

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return [self.topViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.topViewController.preferredStatusBarStyle;
}



+ (void)initialize
{
    // 当导航栏用在YPNavigationController中appearance才会生效
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:[self class], nil];
    [bar setTintColor:YPMainColor];
    NSMutableDictionary *titleAttrs = [NSMutableDictionary dictionary];
    titleAttrs[NSForegroundColorAttributeName] = YPBlackColor;
    titleAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [bar setTitleTextAttributes:titleAttrs];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

/**
 * 可以在这个方法中拦截所有push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) { // 如果push进来的不是第一个控制器
        
        if ([viewController isKindOfClass:NSClassFromString(@"YPBilibiliWebViewController")]) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
            button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
            [button setTitle:@"返回" forState:UIControlStateNormal];
            [button sizeToFit];
            [button setTitleColor:YPMainColor forState:UIControlStateNormal];
            [button setTitleColor:YPMainColor forState:UIControlStateHighlighted];
            @weakify(self);
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                [self popViewControllerAnimated:YES];
            }];
            
            viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        }
        

        // 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    // 这句super的push要放在后面, 让viewController可以覆盖上面设置的leftBarButtonItem
    [super pushViewController:viewController animated:animated];
    
}






@end
