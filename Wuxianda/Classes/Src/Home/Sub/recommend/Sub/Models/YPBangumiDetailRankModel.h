//
//  YPBangumiDetailRankModel.h
//  Wuxianda
//
//  Created by 胡云鹏 on 16/6/18.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPBangumiDetailRankModel : NSObject

@property (nonatomic, copy) NSArray *list;

@property (nonatomic, copy) NSString *total_bp_count;
@property (nonatomic, copy) NSString *week_bp_count;

@end

/**
 "list":Array[4],
 "total_bp_count":902,
 "week_bp_count":77
 */