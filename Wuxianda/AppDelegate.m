//
//  AppDelegate.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/1/21.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "AppDelegate.h"
#import "YPTabBarController.h"
#import "YPNavigationController.h"
#import "YPThirdPartyManager.h"
#import "YPLaunchViewController.h"
#import "YPVideoLaunchViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 设置第三方支持
    [[YPThirdPartyManager manager] setupThirdPartyConfigurationWithApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    // 初始化根控制器
    self.window = [[UIWindow alloc] initWithFrame:YPScreenBounds];
    self.window.backgroundColor = YPWhiteColor;
    
#if 1
    UIViewController *vc = nil;
    int random = arc4random_uniform(100) % 2;
    if (random == 1) {
        vc = [YPLaunchViewController controller];
    } else {
        vc = [YPVideoLaunchViewController controller];
    }
#endif
    
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    

    
    // 网络监测
    [self networkMonitoring];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}

#pragma mark - 网络监测
- (void)networkMonitoring
{
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态发生改变的时候调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI状态");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                YYReachability *reach = [YYReachability reachability];
                YYReachabilityWWANStatus wwanStatus = reach.wwanStatus;
                switch (wwanStatus) {
                    case YYReachabilityWWANStatusNone:
                    {
                        YPLog(@"蜂窝网络");
                        break;
                    }
                    case YYReachabilityWWANStatus2G:
                    {
                        YPLog(@"2G");
                        break;
                    }
                    case YYReachabilityWWANStatus3G:
                    {
                        YPLog(@"3G");
                        break;
                    }
                    case YYReachabilityWWANStatus4G:
                    {
                        YPLog(@"4G");
                        break;
                    }
                    default:
                        break;
                }
                
                break;
            }
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            default:
                break;
        }
    }];
    // 开始监控
    [mgr startMonitoring];
}

#pragma mark - Life Cycle
- (void)dealloc
{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    [YPNotificationCenter removeObserver:self];
}

- (void)signTest
{
#if 0
    @"http://account.bilibili.com/api/myinfo?appkey=27eb53fc9058f8c3&platform=ios&type=json&sign=c8ab17404d90a1c247b19f52301f1911"
#endif
    
    NSString *str = [@"appkey=27eb53fc9058f8c3&platform=ios&type=jsonea85624dfcf12d7cc7b2b3a94fac1f2c" md5String];
    
    YPLog(@"%@",str);
}

@end

















































