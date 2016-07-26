//
//  YPBannerModel.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/5/31.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//



#import "YPBannerModel.h"

@implementation YPBannerModel

#if 0
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"hashStr" : @"hash"};
}
#endif

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"hashStr" : @"hash"
             };
}

@end
