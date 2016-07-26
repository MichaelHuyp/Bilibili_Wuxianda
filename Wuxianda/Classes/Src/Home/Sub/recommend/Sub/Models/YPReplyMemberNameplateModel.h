//
//  YPReplyMemberNameplateModel.h
//  Wuxianda
//
//  Created by 胡云鹏 on 16/6/18.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPReplyMemberNameplateModel : NSObject

@property (nonatomic, copy) NSString *nid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *image_small;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *condition;

@end

/**
 {
 "nid":0,
 "name":"",
 "image":"",
 "image_small":"",
 "level":"",
 "condition":""
 }
 */