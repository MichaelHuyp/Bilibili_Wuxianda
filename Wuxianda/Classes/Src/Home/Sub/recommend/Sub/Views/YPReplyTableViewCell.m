//
//  YPReplyTableViewCell.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/8.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPReplyTableViewCell.h"
#import "YPReplyRepliesModel.h"
#import "UIView+YPLayer.h"
#import "NSDate+YPExtension.h"

@interface YPReplyTableViewCell ()

/** 头像imageView */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

/** 用户名标签 */
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

/** 楼层标签 */
@property (weak, nonatomic) IBOutlet UILabel *floorLabel;

/** 时间标签 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

/** 回复数按钮 */
@property (weak, nonatomic) IBOutlet UIButton *replyCountButton;

/** 喜爱数按钮 */
@property (weak, nonatomic) IBOutlet UIButton *likeCountButton;

/** 举报imageView */
@property (weak, nonatomic) IBOutlet UIImageView *reportImageView;

/** 回复内容标签 */
@property (weak, nonatomic) IBOutlet UILabel *replyContentLabel;

/** 等级imageView */
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;

/** 性别imageView */
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;

@end

@implementation YPReplyTableViewCell


#pragma mark - Override
- (void)awakeFromNib {
    [super awakeFromNib];
    
    // self
    self.autoresizingMask = UIViewAutoresizingNone;
    
    // 头像
    self.iconImageView.layerCornerRadius = self.iconImageView.width * 0.5;
    
    // 回复数按钮
    [self.replyCountButton setImage:[[UIImage imageNamed:@"circle_reply_ic"] imageByTintColor:YPMainColor] forState:UIControlStateNormal];
}


#pragma mark - Setter

- (void)setReplyModel:(YPReplyRepliesModel *)replyModel
{
    _replyModel = replyModel;
    
    // 头像
    [_iconImageView setImageWithURL:[NSURL URLWithString:replyModel.member.avatar] placeholder:nil];
    
    // 用户名
    _usernameLabel.text = replyModel.member.uname;
    
    // 楼层
    _floorLabel.text = [NSString stringWithFormat:@"#%@",replyModel.floor];
    
    // 等级标签
    NSString *levelImageName = [NSString stringWithFormat:@"misc_level_colorfulLv%@",replyModel.member.level_info.current_level];
    
    _levelImageView.image = [UIImage imageNamed:levelImageName];
    
    // 评论内容
    _replyContentLabel.text = replyModel.content.message;
    
    // 评论数
    [_replyCountButton setTitle:replyModel.count forState:UIControlStateNormal];
    
    // 喜爱数
    [_likeCountButton setTitle:replyModel.like forState:UIControlStateNormal];
    
    // 性别
    if ([replyModel.member.sex isEqualToString:@"男"]) {
        _sexImageView.image = [UIImage imageNamed:@"misc_sex_male"];
    } else if ([replyModel.member.sex isEqualToString:@"女"]) {
        _sexImageView.image = [UIImage imageNamed:@"misc_sex_female"];
    } else {
        _sexImageView.image = nil;
    }
    
    // 时间标签处理
    NSDate *replyTime = [NSDate dateWithTimeIntervalSince1970:[replyModel.ctime integerValue]];
    _timeLabel.text = [replyTime create_time];
}





@end































































