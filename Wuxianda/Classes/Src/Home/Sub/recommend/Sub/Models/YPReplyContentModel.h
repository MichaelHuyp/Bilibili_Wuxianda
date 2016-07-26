//
//  YPReplyContentModel.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/17.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  回复内容模型

#import <Foundation/Foundation.h>
#import "YPReplyPageModel.h"

@interface YPReplyContentModel : NSObject

/** page模型 */
@property (nonatomic, strong) YPReplyPageModel *page;

/** replies数组 */
@property (nonatomic, copy) NSArray *replies;

@property (nonatomic, copy) NSString *need_captcha;

@end

/**
 {
 "need_captcha":false,
 "page":Object{...},
 "replies":Array[10]
 }
 */