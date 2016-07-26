//
//  YPReplyHeaderSectionView.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/8.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPReplyHeaderSectionView : UIView


/**
 *  刷新数据源
 *
 *  @param pageNum         第几话
 *  @param replyTotalCount 评论总数
 */
- (void)reloadDataWithPageNum:(NSString *)pageNum replyTotalCount:(NSString *)replyTotalCount;

@end
