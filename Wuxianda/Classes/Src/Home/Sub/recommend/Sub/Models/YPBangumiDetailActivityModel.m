//
//  YPBangumiDetailActivityModel.m
//  Wuxianda
//
//  Created by 胡云鹏 on 16/6/18.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPBangumiDetailActivityModel.h"

@implementation YPBangumiDetailActivityModel

#if 0
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"idStr" : @"id"};
}
#endif

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"idStr" : @"id"
             };
}

@end
