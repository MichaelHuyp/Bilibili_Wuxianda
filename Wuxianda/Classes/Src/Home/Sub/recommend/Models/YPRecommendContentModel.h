//
//  YPRecommendContentModel.h
//  Wuxianda
//
//  Created by 胡云鹏 on 16/6/9.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  推荐内容模型

/**
 "param":"",
 "type":"recommend",
 "style":"medium",
 "title":"热门焦点",
 "body":Array[4]
 */

#import <Foundation/Foundation.h>

@interface YPRecommendContentModel : NSObject

/**
 *  这个参数对应图片资源中的home_region_icon_@(param) 图片资源。。。
 */
@property (nonatomic, copy) NSString *param;
/**
 *  用于区分cell的类型
 */
@property (nonatomic, copy) NSString *type;

/**
 *  布局类型
 *  medium : 4图 九宫格排布
 *  large : 大图 居中排布
 *  small : 电视剧 小图布局可滑动
 */
@property (nonatomic, copy) NSString *style;
@property (nonatomic, copy) NSString *title;

/**
 *  直播特有参数
 */
@property (nonatomic, copy) NSString *live_count;

@property (nonatomic, copy) NSArray *body;

@end















