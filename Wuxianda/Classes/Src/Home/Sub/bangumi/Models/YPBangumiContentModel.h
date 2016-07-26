//
//  YPBangumiContentModel.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/20.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPBangumiContentModel : NSObject

/** 封面 */
@property (nonatomic, copy) NSString *cover;

/** 光标。。 下次下拉刷新时用到 不过因为加密没法发送网络请求 */
@property (nonatomic, copy) NSString *cursor;

/** 描述 */
@property (nonatomic, copy) NSString *desc;

/** id */
@property (nonatomic, copy) NSString *idStr;

/** 是否为新番 */
@property (nonatomic, copy) NSString *is_new;

/** 链接地址 */
@property (nonatomic, copy) NSString *link;

/** 标题 */
@property (nonatomic, copy) NSString *title;


@end
