//
//  YPThirdPartyManager.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/4/29.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  第三方接入管理者

#import <Foundation/Foundation.h>
#import "BaiduMapConst.h"
#import "UMConst.h"


// 百度地图
#define kBaiduMapAppKey @"QBYw0OI0LwB1q3poQRQZiq4drnmOAXWq"
// 友盟
#define kUMAppKey @"57625aeae0f55a9b8f001175"
// 微信
#define kWechatAppID @"wx583a9239406dfa5f"
#define kWechatAppSecret @"d4624c36b6795d1d99dcf0547af5443d"
// QQ
#define kQQAppID @"1105476106"
#define kQQAppKey @"FtXkR3atEHANB4tG"
// 新浪微博
#define kSinaAppKey @"1576468831"
#define kSinaAppSecret @"22316f7a15b1733d8761c33f8876ba2b"

@interface YPThirdPartyManager : NSObject

+ (instancetype)manager;

/**
 *  设置第三方支持配置
 */
- (void)setupThirdPartyConfigurationWithApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

@end
