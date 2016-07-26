//
//  YPBangumiDetailTagsModel.h
//  Wuxianda
//
//  Created by 胡云鹏 on 16/6/18.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPBangumiDetailTagsModel : NSObject

@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *index;
@property (nonatomic, copy) NSString *orderType;
@property (nonatomic, copy) NSString *style_id;
@property (nonatomic, copy) NSString *tag_id;
@property (nonatomic, copy) NSString *tag_name;
@property (nonatomic, copy) NSString *type;

@end

/**
 {
 "cover":"http://i2.hdslb.com/u_user/c0545cad7e464f1f3cb26ba258c9a45d.jpg",
 "index":"180",
 "orderType":0,
 "style_id":"21",
 "tag_id":"22",
 "tag_name":"致郁",
 "type":"0"
 }
 */