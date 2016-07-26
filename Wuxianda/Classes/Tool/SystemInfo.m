//
//  SystemInfo.m
//  xinfenbao
//
//  Created by MichaelPPP on 15/11/16.
//  Copyright (c) 2015年 tianyuanwangluo. All rights reserved.
//

#import "SystemInfo.h"
#include <arpa/inet.h>
#include <errno.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <netdb.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/sockio.h>
#include <sys/sysctl.h>
#include <sys/types.h>
#include <unistd.h>
//#import "IPAddress.h"

@implementation SystemInfo

+ (NSString*)osVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString*)platform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char* machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString* platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

+ (NSString*)platformString
{
    NSString* platform = [self platform];

    if ([platform isEqualToString:@"iPhone1,1"])
        return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"])
        return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"])
        return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"])
        return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"])
        return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"])
        return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"])
        return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"])
        return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"])
        return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"])
        return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"])
        return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"])
        return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"])
        return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"])
        return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"])
        return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"])
        return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])
        return @"iPhone 6s Plus";

    if ([platform isEqualToString:@"iPod1,1"])
        return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])
        return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])
        return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])
        return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])
        return @"iPod Touch 5G (A1421/A1509)";

    if ([platform isEqualToString:@"iPad1,1"])
        return @"iPad 1G (A1219/A1337)";

    if ([platform isEqualToString:@"iPad2,1"])
        return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])
        return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])
        return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])
        return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])
        return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])
        return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])
        return @"iPad Mini 1G (A1455)";

    if ([platform isEqualToString:@"iPad3,1"])
        return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])
        return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])
        return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])
        return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])
        return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])
        return @"iPad 4 (A1460)";

    if ([platform isEqualToString:@"iPad4,1"])
        return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])
        return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])
        return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])
        return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])
        return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])
        return @"iPad Mini 2G (A1491)";

    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"])
        return @"iPhone Simulator";

    return platform;
}

//获取系统当前时间
+ (NSString*)systemTimeInfo
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* currentDateString = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateString;
}

+ (NSString*)appVersion
{
    NSString* version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    return [NSString stringWithFormat:@"%@", version];
}

+ (BOOL)is_iPhone_5
{
    if ([UIScreen mainScreen].bounds.size.height == 568.0f) {
        return YES;
    }
    else {
        return NO;
    }
}

#pragma mark -
#pragma mark jailbreaker

static const char* __jb_app = NULL;

#if 0
+ (BOOL)isJailBroken
{
    static const char* __jb_apps[] = {
        "/Application/Cydia.app",
        "/Application/limera1n.app",
        "/Application/greenpois0n.app",
        "/Application/blackra1n.app",
        "/Application/blacksn0w.app",
        "/Application/redsn0w.app",
        NULL
    };

    __jb_app = NULL;

    // method 1
    for (int i = 0; __jb_apps[i]; ++i) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:__jb_apps[i]]]) {
            __jb_app = __jb_apps[i];
            return YES;
        }
    }

    // method 2
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"]) {
        return YES;
    }

    // method 3
    if (0 == system("ls")) {
        return YES;
    }

    return NO;
}
#endif

+ (NSString*)jailBreaker
{
    if (__jb_app) {
        return [NSString stringWithUTF8String:__jb_app];
    }
    else {
        return @"";
    }
}

//+ (NSString *)localIPAddress
//{
//    InitAddresses();
//
//    GetIPAddresses();
//
//    GetHWAddresses();
//
//    return [NSString stringWithFormat:@"%s", ip_names[1]];
//}

+ (NSString*)getCarrierName
{
    CTTelephonyNetworkInfo* telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier* carrier = [telephonyInfo subscriberCellularProvider];
    return [carrier carrierName];
}

//+ (NSString*)uuidSolution
//{
//    NSUUID* uuid = [[UIDevice currentDevice] identifierForVendor];
//    NSString* uuidString = [uuid UUIDString];
//    uuidString = [SFHFKeychainUtils getPasswordForUsername:kKeyChainUUIDKey andServiceName:kKeyChainGroupKey error:nil];
//
//    if (!uuidString) {
//        uuidString = [self uuidString];
//        [SFHFKeychainUtils storeUsername:kKeyChainUUIDKey andPassword:uuidString forServiceName:kKeyChainGroupKey updateExisting:NO error:nil];
//    }
//    return uuidString;
//}
//
//+ (NSString*)uuidString
//{
//    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
//    CFStringRef stringRef = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
//    NSString* uuidstring = (__bridge NSString*)(stringRef);
//    CFRelease(uuidRef);
//    return uuidstring;
//}

@end
