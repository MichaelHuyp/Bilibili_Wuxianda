//
//  YPReplyTableFooterView.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/8.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPReplyTableFooterView.h"

@interface YPReplyTableFooterView ()

/** 更多评论按钮 */
@property (weak, nonatomic) IBOutlet UIButton *moreReplyBtn;
@end

@implementation YPReplyTableFooterView


#pragma mark - Override
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // self
    self.autoresizingMask = UIViewAutoresizingNone;
}

@end
