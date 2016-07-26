//
//  YPThirdPartyManager.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/4/29.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPThirdPartyManager.h"


@interface YPThirdPartyManager ()

@property (nonatomic, strong) BMKMapManager *mapManager;

@end

@implementation YPThirdPartyManager

- (BMKMapManager *)mapManager
{
    if (!_mapManager) {
        // 要使用百度地图，请先启动BaiduMapManager
        _mapManager = [[BMKMapManager alloc] init];
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        BOOL ret = [_mapManager start:kBaiduMapAppKey generalDelegate:nil];
        if (!ret) {
            YPLog(@"manager start failed!");
        } else {
            YPLog(@"百度地图授权成功");
        }
        
#if 0
        [BNCoreServices_Instance initServices:kBaiduMapAppKey];
        [BNCoreServices_Instance startServicesAsyn:^{
            YPLog(@"百度导航初始化成功");
        } fail:^{
            YPLog(@"百度导航初始化失败");
        }];
#endif
    }
    return _mapManager;
}

+ (instancetype)manager
{
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)setupThirdPartyConfigurationWithApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /** 百度地图平台 */
//    [self mapManager];
    

    /** 友盟分享 */
    
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:kUMAppKey];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:kWechatAppID appSecret:kWechatAppSecret url:@"http://www.umeng.com/social"];
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:kQQAppID appKey:kQQAppKey url:@"http://www.umeng.com/social"];
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。需要 #import "UMSocialSinaSSOHandler.h"
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:kSinaAppKey
                                              secret:kSinaAppSecret
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
}

@end





































