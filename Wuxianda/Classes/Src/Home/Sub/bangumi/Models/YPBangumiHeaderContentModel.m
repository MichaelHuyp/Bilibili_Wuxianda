//
//  YPBangumiHeaderContentModel.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/20.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPBangumiHeaderContentModel.h"

@implementation YPBangumiHeaderContentModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"banners" : @"YPBangumiHeaderContentBannerModel",
             @"ends" : @"YPBangumiCommonModel"
             };
}

@end
