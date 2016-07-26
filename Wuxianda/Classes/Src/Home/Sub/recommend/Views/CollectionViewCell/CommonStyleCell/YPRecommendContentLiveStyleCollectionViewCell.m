//
//  YPRecommendContentLiveStyleCollectionViewCell.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/13.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPRecommendContentLiveStyleCollectionViewCell.h"
#import "YPRecommendContentBodyModel.h"
#import "UIImageView+WebCache.h"

@interface YPRecommendContentLiveStyleCollectionViewCell ()

/** 内容图片 */
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
/** 头像图片 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

/** up主名字标签 */
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
/** 观看人数标签 */
@property (weak, nonatomic) IBOutlet UILabel *onlineCountLabel;
/** 标题标签 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/** 内容图片占位图 */
@property (nonatomic, strong) UIImage *contentImageViewPlaceholderImage;
/** 头像图片占位图 */
@property (nonatomic, strong) UIImage *iconImageViewPlaceholderImage;

@end

@implementation YPRecommendContentLiveStyleCollectionViewCell

#pragma mark - Lazy
- (UIImage *)contentImageViewPlaceholderImage
{
    if (!_contentImageViewPlaceholderImage) {
        CGFloat margin = 8;
        CGFloat width = (YPScreenW - 3 * margin) * 0.5;
        CGFloat height = 120;
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
    
    _contentImageView.layer.cornerRadius = 5;
    _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    _contentImageView.clipsToBounds = YES;
    
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImageView.clipsToBounds = YES;
}

#pragma mark - Setter
- (void)setModel:(YPRecommendContentBodyModel *)model
{
    _model = model;
    
    _authorNameLabel.text = model.name;
    _onlineCountLabel.text = model.online;
    _titleLabel.text = model.title;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.face] placeholderImage:[UIImage yp_circleImageWithOldImage:self.iconImageViewPlaceholderImage borderWidth:3 borderColor:YPWhiteColor] options:SDWebImageAvoidAutoSetImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        _iconImageView.image = image ? [UIImage yp_circleImageWithOldImage:image borderWidth:3 borderColor:YPWhiteColor] : [UIImage yp_circleImageWithOldImage:self.iconImageViewPlaceholderImage borderWidth:3 borderColor:YPWhiteColor];
    }];
    
    
    [_contentImageView setImageWithURL:[NSURL URLWithString:model.cover] placeholder:self.contentImageViewPlaceholderImage options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation completion:nil];
}

@end






























