//
//  YPBangumiHeaderContentModel.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/20.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  番剧头部视图模型

#import <Foundation/Foundation.h>
#import "YPBangumiHeaderContentLatestUpdateModel.h"

@interface YPBangumiHeaderContentModel : NSObject

@property (nonatomic, copy) NSArray *banners;
@property (nonatomic, copy) NSArray *ends;


@property (nonatomic, strong) YPBangumiHeaderContentLatestUpdateModel *latestUpdate;


@end
