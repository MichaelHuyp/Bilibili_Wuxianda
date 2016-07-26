//
//  SystemInfo.h
//  xinfenbao
//
//  Created by MichaelPPP on 15/11/16.
//  Copyright (c) 2015年 tianyuanwangluo. All rights reserved.
//  系统信息工具类

//#import "SFHFKeychainUtils.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define IOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending)
#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
#define IOS6_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending)
#define IOS5_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"5.0"] != NSOrderedAscending)
#define IOS4_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"4.0"] != NSOrderedAscending)
#define IOS3_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"3.0"] != NSOrderedAscending)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE_5 [SNSystemInfo is_iPhone_5];

@interface SystemInfo : NSObject

/*系统版本*/
+ (NSString*)osVersion;

/*硬件版本*/
+ (NSString*)platform;

/*硬件版本名称*/
+ (NSString*)platformString;

/*系统当前时间 格式：yyyy-MM-dd HH:mm:ss*/
+ (NSString*)systemTimeInfo;

/*软件版本*/
+ (NSString*)appVersion;

/*是否是iPhone5*/
+ (BOOL)is_iPhone_5;

/*是否越狱*/
//+ (BOOL)isJailBroken;

/*越狱版本*/
+ (NSString*)jailBreaker;

/*本地ip*/
//+ (NSString *)localIPAddress;

/** 获取运营商 */
+ (NSString*)getCarrierName;

/** UUID解决方案 */
//+ (NSString*)uuidSolution;



@end
