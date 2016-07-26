//
//  YPReplyContentModel.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/17.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPReplyContentModel.h"

@implementation YPReplyContentModel

#if 0
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"replies" : @"YPReplyRepliesModel"
             };
}
#endif

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{
             @"replies" : @"YPReplyRepliesModel"
             };
}

@end
