//
//  YPBangumiHeaderContentBannerModel.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/20.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  番剧头部视图广告牌模型

#import <Foundation/Foundation.h>

@interface YPBangumiHeaderContentBannerModel : NSObject

/** 番剧图片 */
@property (nonatomic, copy) NSString *imageUrl;

/** 番剧链接 */
@property (nonatomic, copy) NSString *link;

/** 番剧标题 */
@property (nonatomic, copy) NSString *title;

@end
