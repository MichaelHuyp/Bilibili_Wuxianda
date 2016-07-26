//
//  YPReplyRealContentModel.m
//  Wuxianda
//
//  Created by 胡云鹏 on 16/6/18.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPReplyRealContentModel.h"

@implementation YPReplyRealContentModel

#if 0
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"members" : @"YPReplyMemberModel"
             };
}
#endif

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{
             @"members" : @"YPReplyMemberModel"
             };
}

@end
