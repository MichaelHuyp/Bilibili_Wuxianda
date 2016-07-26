//
//  YPBangumiRecommondTableViewCell.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/21.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPBangumiRecommondTableViewCell.h"
#import "YPBangumiContentModel.h"

@interface YPBangumiRecommondTableViewCell ()

/** 封面 */
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

/** 是否为新番标识 */
@property (weak, nonatomic) IBOutlet UIImageView *isNewFlagImageView;

/** 标题标签 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/** 详情标签 */
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (nonatomic, strong) UIImage *placeholderImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverImageViewHeightCons;

@end

@implementation YPBangumiRecommondTableViewCell

#pragma mark - Lazy
- (UIImage *)placeholderImage
{
    if (!_placeholderImage) {
        /**
         *   960    x   300
         *   width  x    ?
         */
        CGFloat width = YPScreenW - 2 * kAppPadding_8;
        CGFloat height = width * 300 / 960;
        UIImage *placeholder = [UIImage yp_generateCenterImageWithBgColor:YPMainPlaceHolderBgColor bgImageSize:CGSizeMake(width, height) centerImage:[UIImage imageNamed:@"default_img"]];
        _placeholderImage = placeholder;
    }
    return _placeholderImage;
}

#pragma mark - Override

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // self
    self.autoresizingMask = UIViewAutoresizingNone;
    self.backgroundColor = YPMainBgColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat width = YPScreenW - 2 * kAppPadding_8;
    CGFloat height = width * 300 / 960;
    _coverImageViewHeightCons.constant = height;
    [self layoutIfNeeded];

}

#pragma mark - Setter

- (void)setModel:(YPBangumiContentModel *)model
{
    _model = model;
    
    // coverimageView
    [_coverImageView setImageWithURL:[NSURL URLWithString:model.cover] placeholder:self.placeholderImage options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    
    // label
    _titleLabel.text = model.title;
    
    _detailLabel.text = model.desc;
    
    // new flag
    _isNewFlagImageView.hidden = (![model.is_new boolValue]);
    
}


@end
































