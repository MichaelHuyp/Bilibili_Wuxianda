//
//  YPLiveBannerModel.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/11.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  直播模块轮播图模型

#import <Foundation/Foundation.h>

@interface YPLiveBannerModel : NSObject

/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 图片 */
@property (nonatomic, copy) NSString *imageUrl;
/** 备注 */
@property (nonatomic, copy) NSString *remark;
/** 链接 */
@property (nonatomic, copy) NSString *link;

@end
