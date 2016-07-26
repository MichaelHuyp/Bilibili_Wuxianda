//
//  YPReplyMemberPendantModel.h
//  Wuxianda
//
//  Created by 胡云鹏 on 16/6/18.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPReplyMemberPendantModel : NSObject

@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *expire;

@end

/**
 {
 "pid":0,
 "name":"",
 "image":"",
 "expire":0
 }
 */