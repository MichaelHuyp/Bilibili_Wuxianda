//
//  YPReplyHeaderSectionView.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/8.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPReplyHeaderSectionView.h"
#import "YPReversedLeftToRightButton.h"

@interface YPReplyHeaderSectionView ()

/** 详情标签（第xx话 评论（xxxx）） */
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

/** 更多评论按钮 */
@property (weak, nonatomic) IBOutlet YPReversedLeftToRightButton *moreReplyBtn;

@end

@implementation YPReplyHeaderSectionView

#pragma mark - Public
- (void)reloadDataWithPageNum:(NSString *)pageNum replyTotalCount:(NSString *)replyTotalCount
{
    _detailLabel.text = [NSString stringWithFormat:@"第%@话 评论（%@）",pageNum,replyTotalCount];
}

#pragma mark - Override
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // self
    self.autoresizingMask = UIViewAutoresizingNone;
    
}





@end
