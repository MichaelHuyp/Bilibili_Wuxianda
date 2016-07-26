//
//  YPLaunchModel.m
//  Wuxianda
//
//  Created by 胡云鹏 on 16/5/21.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPLaunchModel.h"

@implementation YPLaunchModel

#if 0
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"idStr" : @"id"};
}
#endif

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"idStr" : @"id"
             };
}

@end
