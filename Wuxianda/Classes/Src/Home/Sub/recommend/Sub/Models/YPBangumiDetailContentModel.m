//
//  YPBangumiDetailContentModel.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/17.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPBangumiDetailContentModel.h"

@implementation YPBangumiDetailContentModel

#if 0
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"actor" : @"YPBangumiDetailActorModel",
             @"episodes" : @"YPBangumiDetailEpisodesModel",
             @"related_seasons" : @"YPBangumiDetailRelated_seasonsModel",
             @"seasons" : @"YPBangumiDetailSeasonsModel",
             @"tag2s" : @"YPBangumiDetailTag2sModel",
             @"tags" : @"YPBangumiDetailTagsModel"
             };
}
#endif

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"actor" : @"YPBangumiDetailActorModel",
             @"episodes" : @"YPBangumiDetailEpisodesModel",
             @"related_seasons" : @"YPBangumiDetailRelated_seasonsModel",
             @"seasons" : @"YPBangumiDetailSeasonsModel",
             @"tag2s" : @"YPBangumiDetailTag2sModel",
             @"tags" : @"YPBangumiDetailTagsModel"
             };
}

@end
