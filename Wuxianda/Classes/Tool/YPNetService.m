//
//  YPNetService.m
//  xinfenbao
//
//  Created by MichaelPPP on 15/12/14.
//  Copyright (c) 2015年 tianyuanwangluo. All rights reserved.
//

#import "YPNetService.h"
#import <SystemConfiguration/SystemConfiguration.h>

@implementation YPNetService
+ (instancetype)shareInstance
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#if 0
- (BOOL)isProtocolService
{
    NSDictionary* proxySettings = NSMakeCollectable((__bridge CFTypeRef)((__bridge NSDictionary*)CFNetworkCopySystemProxySettings()));

    NSArray* proxies = NSMakeCollectable((__bridge NSArray*)CFNetworkCopyProxiesForURL((__bridge CFURLRef)[NSURL URLWithString:@"https://www.google.com"], (__bridge CFDictionaryRef)proxySettings));

    NSDictionary* settings = [proxies firstObject];

    if ([settings objectForKey:(NSString*)kCFProxyHostNameKey] == nil && [settings objectForKey:(NSString*)kCFProxyPortNumberKey] == nil) {
        return NO;
    }
    return YES;
}
#endif
@end
