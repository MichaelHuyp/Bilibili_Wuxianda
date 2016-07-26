//
//  YPReplyMemberModel.h
//  Wuxianda
//
//  Created by 胡云鹏 on 16/6/18.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YPReplyMemberLevel_infoModel.h"
#import "YPReplyMemberPendantModel.h"
#import "YPReplyMemberNameplateModel.h"

@interface YPReplyMemberModel : NSObject

/** level_info模型 */
@property (nonatomic, strong) YPReplyMemberLevel_infoModel *level_info;
/** pendant模型 */
@property (nonatomic, strong) YPReplyMemberPendantModel *pendant;
/** nameplate模型 */
@property (nonatomic, strong) YPReplyMemberNameplateModel *nameplate;

@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *uname;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *rank;
@property (nonatomic, copy) NSString *DisplayRank;

@end

/**
 {
 "mid":"638709",
 "uname":"Matriel",
 "sex":"男",
 "sign":"NOTHING",
 "avatar":"http://i0.hdslb.com/bfs/face/8846f32916cdc7b62f7f1f2dbbb048bfab3277ac.jpg",
 "rank":"10000",
 "DisplayRank":"10000",
 "level_info":Object{...},
 "pendant":Object{...},
 "nameplate":Object{...}
 }
 */