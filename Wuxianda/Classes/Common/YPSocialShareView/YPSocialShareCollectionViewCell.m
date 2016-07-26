//
//  YPSocialShareCollectionViewCell.m
//  Wuxianda
//
//  Created by 胡云鹏 on 16/6/16.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPSocialShareCollectionViewCell.h"
#import "YPSocialShareModel.h"

@interface YPSocialShareCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation YPSocialShareCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(YPSocialShareModel *)model
{
    _model = model;
    
    _iconImageView.image = [UIImage imageNamed:model.image];
    _titleLabel.text = model.title;
}

@end
