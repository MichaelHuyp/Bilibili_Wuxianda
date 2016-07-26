//
//  YPRecommendContentModel.m
//  Wuxianda
//
//  Created by 胡云鹏 on 16/6/9.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPRecommendContentModel.h"

@implementation YPRecommendContentModel


#if 0
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"body" : @"YPRecommendContentBodyModel"};
}
#endif

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"body" : @"YPRecommendContentBodyModel"
             };
}

@end
