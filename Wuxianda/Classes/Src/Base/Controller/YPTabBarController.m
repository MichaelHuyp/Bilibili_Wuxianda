//
//  YPTabBarController.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/1/21.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPTabBarController.h"
#import "YPNavigationController.h"
#import "YPHomeController.h"
#import "YPProfileViewController.h"

@interface YPTabBarController () <UITabBarControllerDelegate>

@end

@implementation YPTabBarController

#pragma mark - 屏幕旋转控制方法
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return [self.selectedViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (BOOL)shouldAutorotate
{
    return self.selectedViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return self.selectedViewController.supportedInterfaceOrientations;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.selectedViewController.preferredStatusBarStyle;
}

#pragma mark - Override
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    self.tabBar.tintColor = YPMainColor;
    
    [self addChildVc:[YPHomeController controller] andTitle:@"首页" andImage:@"home_home_tab" andSelectedImage:@"home_home_tab_s"];
    
    [self addChildVc:[YPProfileViewController controller] andTitle:@"我的" andImage:@"home_mine_tab" andSelectedImage:@"home_mine_tab_s"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}


#pragma mark - Private
- (void)addChildVc:(UIViewController*)childVc andTitle:(NSString*)title andImage:(NSString*)image andSelectedImage:(NSString*)selectedImage
{
    childVc.tabBarItem.title = title;
    
    childVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    YPNavigationController* nav = [[YPNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}



#pragma mark - UITabBarDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [YPNotificationCenter postNotificationName:YPTabBarDidSelectNotification object:nil userInfo:nil];
}


@end
