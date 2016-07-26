//
//  NSObject+YPExtension.m
//  xinfenbao
//
//  Created by MichaelPPP on 15/12/21.
//  Copyright (c) 2015年 tianyuanwangluo. All rights reserved.
//

#import "NSObject+YPExtension.h"
#import <objc/runtime.h>

@implementation NSObject (YPExtension)
#if (TARGET_OS_IPHONE)
- (NSString*)className
{
    return [NSString stringWithUTF8String:class_getName([self class])];
}
+ (NSString*)className
{
    return [NSString stringWithUTF8String:class_getName(self)];
}
#endif
@end
