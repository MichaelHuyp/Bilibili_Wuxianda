//
//  YPReplyRepliesModel.h
//  Wuxianda
//
//  Created by 胡云鹏 on 16/6/18.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YPReplyMemberModel.h"
#import "YPReplyRealContentModel.h"

@interface YPReplyRepliesModel : NSObject

/** member模型 */
@property (nonatomic, strong) YPReplyMemberModel *member;

/** content模型 */
@property (nonatomic, strong) YPReplyRealContentModel *content;

/** replies模型 */
@property (nonatomic, copy) NSArray *replies;

@property (nonatomic, copy) NSString *rpid;
@property (nonatomic, copy) NSString *oid;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *root;
@property (nonatomic, copy) NSString *parent;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *rcount;
@property (nonatomic, copy) NSString *floor;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *ctime;
@property (nonatomic, copy) NSString *rpid_str;
@property (nonatomic, copy) NSString *root_str;
@property (nonatomic, copy) NSString *parent_str;
@property (nonatomic, copy) NSString *like;
@property (nonatomic, copy) NSString *action;

@end

/**
 {
 "rpid":92573132,
 "oid":4245141,
 "type":1,
 "mid":638709,
 "root":0,
 "parent":0,
 "count":297,
 "rcount":295,
 "floor":999,
 "state":0,
 "ctime":1459566314,
 "rpid_str":"92573132",
 "root_str":"0",
 "parent_str":"0",
 "like":2580,
 "action":0,
 "member":Object{...},
 "content":Object{...},
 "replies":Array[5]
 }
 */