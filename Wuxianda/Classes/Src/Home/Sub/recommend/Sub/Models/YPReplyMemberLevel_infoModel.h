//
//  YPReplyMemberLevel_infoModel.h
//  Wuxianda
//
//  Created by 胡云鹏 on 16/6/18.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPReplyMemberLevel_infoModel : NSObject

@property (nonatomic, copy) NSString *current_level;
@property (nonatomic, copy) NSString *current_min;
@property (nonatomic, copy) NSString *current_exp;
@property (nonatomic, copy) NSString *next_exp;

@end

/**
 {
 "current_level":4,
 "current_min":4500,
 "current_exp":5840,
 "next_exp":10800
 }
 */