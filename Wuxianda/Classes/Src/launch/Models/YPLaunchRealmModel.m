//
//  YPLaunchRealmModel.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/5/31.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPLaunchRealmModel.h"
#import "YPLaunchModel.h"

@implementation YPLaunchRealmModel

#pragma mark - Public
- (instancetype)initWithModel:(YPLaunchModel *)model
{
    self = [super init];
    if (!self) return nil;
    self.image = model.image;
    self.start_time = model.start_time;
    self.end_time = model.end_time;
    self.duration = model.duration;
    self.times = model.times;
    return self;
}

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
