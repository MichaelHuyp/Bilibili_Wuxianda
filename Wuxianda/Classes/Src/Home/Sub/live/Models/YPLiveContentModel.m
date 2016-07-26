//
//  YPLiveContentModel.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/11.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPLiveContentModel.h"

@implementation YPLiveContentModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"banner" : @"YPLiveBannerModel",
             @"entranceIcons" : @"YPLiveEntranceIconModel",
             @"partitions" : @"YPLivePartitionModel"
             };
}

@end
