//
//  Foundation+YPLog.m
//  YPExtension
//
//  Created by 胡云鹏 on 15/8/18.
//  Copyright (c) 2015年 MichaelPPP. All rights reserved.
//

#import <Foundation/Foundation.h>

@implementation NSDictionary (Log)
- (NSString*)descriptionWithLocale:(id)locale
{
    NSMutableString* str = [NSMutableString string];

    [str appendString:@"{\n"];

    // 遍历字典的所有键值对
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
        [str appendFormat:@"\t%@ = %@,\n", key, obj];
    }];

    [str appendString:@"}"];

    // 查出最后一个,的范围
    NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length != 0) {
        // 删掉最后一个,
        [str deleteCharactersInRange:range];
    }

    return str;
}
@end

@implementation NSArray (Log)
- (NSString*)descriptionWithLocale:(id)locale
{
    NSMutableString* str = [NSMutableString string];

    [str appendString:@"[\n"];

    // 遍历数组的所有元素
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        [str appendFormat:@"%@,\n", obj];
    }];

    [str appendString:@"]"];

    // 查出最后一个,的范围
    NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length != 0) {
        // 删掉最后一个,
        [str deleteCharactersInRange:range];
    }

    return str;
}
@end
