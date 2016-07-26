//
//  YPLiveContentCollectionViewCell.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/13.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPLiveContentCollectionViewCell.h"
#import "YPLiveModel.h"
#import "UIView+YPLayer.h"
#import "UIImageView+WebCache.h"

@interface YPLiveContentCollectionViewCell ()

/** 封面imageView高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverImageViewHeightCons;

/** 封面imageView */
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

/** 头像imageView */
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

/** up主名字标签 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/** 观众在线人数标签 */
@property (weak, nonatomic) IBOutlet UILabel *viewerCountLabel;

/** 标题标签 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) UIImage *iconImageViewPlaceholderImage;

@property (nonatomic, strong) UIImage *contentImageViewPlaceholderImage;

@end

@implementation YPLiveContentCollectionViewCell

#pragma mark - Lazy

- (UIImage *)contentImageViewPlaceholderImage
{
    if (!_contentImageViewPlaceholderImage) {
        CGFloat width = (YPScreenW - 3 * kAppPadding_8) * 0.5;
        CGFloat height = width * 180 / 320;
        UIImage *placeholder = [UIImage yp_generateCenterImageWithBgColor:YPMainPlaceHolderBgColor bgImageSize:CGSizeMake(width, height) centerImage:[UIImage imageNamed:@"default_img"]];
        _contentImageViewPlaceholderImage = placeholder;
    }
    return _contentImageViewPlaceholderImage;
}


- (UIImage *)iconImageViewPlaceholderImage
{
    if (!_iconImageViewPlaceholderImage) {
        UIImage *placeholder = [UIImage yp_generateCenterImageWithBgColor:YPMainPlaceHolderBgColor bgImageSize:CGSizeMake(44, 44) centerImage:[UIImage imageNamed:@"default_img"]];
        _iconImageViewPlaceholderImage = placeholder;
    }
    return _iconImageViewPlaceholderImage;
}

#pragma mark - Override
- (void)awakeFromNib {
    [super awakeFromNib];
    
    // self
    self.autoresizingMask = UIViewAutoresizingNone;
    self.backgroundColor = YPMainBgColor;
    
    // 头像
    _avatarImageView.layerCornerRadius = _avatarImageView.width * 0.5;
    _avatarImageView.layerBorderColor = YPWhiteColor;
    _avatarImageView.layerBorderWidth = 1;
    
    // 观众数label
    _viewerCountLabel.layerCornerRadius = 4;
    _viewerCountLabel.layerBorderWidth = 1;
    _viewerCountLabel.layerBorderColor = YPLightLineColor;
}

#pragma mark - Setter
- (void)setModel:(YPLiveModel *)model
{
    _model = model;
    
    // 头像
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.owner.face] placeholderImage:self.iconImageViewPlaceholderImage];
    
    // 封面
    CGFloat width = (YPScreenW - 3 * kAppPadding_8) * 0.5;
    CGFloat height = width * 180 / 320;
    @weakify(self);
    [_coverImageView setImageWithURL:[NSURL URLWithString:model.cover.src] placeholder:[self.contentImageViewPlaceholderImage imageByRoundCornerRadius:4] options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        UIImage *targetImage = [image imageByResizeToSize:CGSizeMake(width, height) contentMode:UIViewContentModeScaleAspectFill];
        @strongify(self);
        self.coverImageView.image = [targetImage imageByRoundCornerRadius:4];
    }];
    _coverImageViewHeightCons.constant = height;
    [self layoutIfNeeded];
    
    // 名字
    _nameLabel.text = model.owner.name;
    
    // 观众数
    _viewerCountLabel.text = model.online;
    
    // 标题
    _titleLabel.text = model.title;
    
    
}

@end









































