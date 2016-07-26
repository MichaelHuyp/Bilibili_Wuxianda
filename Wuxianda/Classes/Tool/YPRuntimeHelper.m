//
//  YPRuntimeHelper.m
//  xinfenbao
//
//  Created by MichaelPPP on 15/12/22.
//  Copyright (c) 2015年 tianyuanwangluo. All rights reserved.
//

#import "YPRuntimeHelper.h"
#import <objc/runtime.h>

@implementation YPRuntimeHelper

+ (instancetype)shareInstance
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSArray*)extractPropertyNamesFromOjbect:(NSObject*)object
{
    NSMutableArray* propertyNames = [NSMutableArray array];

    unsigned int outCount;
    objc_property_t* properties = class_copyPropertyList([object class], &outCount);

    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        [propertyNames addObject:[NSString stringWithUTF8String:property_getName(property)]];
    }

    free(properties);

    return [propertyNames copy];
}

- (NSArray*)extractValuesFromObject:(NSObject*)object forPropertiesWithClass:(NSString*)className
{
    NSArray* propertyNames = [self extractPropertyNamesFromOjbect:object];
    NSMutableArray* propertyValues = [NSMutableArray array];

    for (NSString* property in propertyNames) {
        id value = [object valueForKey:property];

        if ([value isKindOfClass:(NSClassFromString(className))]) {
            [propertyValues addObject:value];
        }
    }
    return [propertyValues copy];
}

- (NSArray*)extractValuesFromObject:(NSObject*)object forPropertiesWithProtocol:(NSString*)protocolName
{
    NSArray* propertyNames = [self extractPropertyNamesFromOjbect:object];
    NSMutableArray* propertyValues = [NSMutableArray array];

    for (NSString* property in propertyNames) {
        id value = [object valueForKey:property];

        if ([value conformsToProtocol:(NSProtocolFromString(protocolName))]) {
            [propertyValues addObject:value];
        }
    }
    return [propertyValues copy];
}

@end
