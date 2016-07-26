//
//  YPRecommendContentBangumiStyleCollectionViewCell.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/13.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPRecommendContentBangumiStyleCollectionViewCell.h"
#import "YPRecommendContentBodyModel.h"

@interface YPRecommendContentBangumiStyleCollectionViewCell ()

/** 图像 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/** 标题标签 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/**
 *  详情标签（包含业务逻辑）
 *  更新时间 · 第xx话
 */
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

/** 占位图 */
@property (nonatomic, strong) UIImage *placeholderImage;

@end

@implementation YPRecommendContentBangumiStyleCollectionViewCell


#pragma mark - Lazy
- (UIImage *)placeholderImage
{
    if (!_placeholderImage) {
        CGFloat margin = 8;
        CGFloat width = (YPScreenW - 3 * margin) * 0.5;
        CGFloat height = 120;
        UIImage *placeholder = [UIImage yp_generateCenterImageWithBgColor:YPMainPlaceHolderBgColor bgImageSize:CGSizeMake(width, height) centerImage:[UIImage imageNamed:@"default_img"]];
        _placeholderImage = placeholder;
    }
    return _placeholderImage;
}

#pragma mark - Override
- (void)awakeFromNib {
    [super awakeFromNib];
    
    _imageView.layer.cornerRadius = 5;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
}

#pragma mark - Setter
- (void)setModel:(YPRecommendContentBodyModel *)model
{
    _model = model;
    
    _titleLabel.text = model.title;
    _detailLabel.text = @"业务逻辑 []~(￣▽￣)~*";
    
    [_imageView setImageWithURL:[NSURL URLWithString:model.cover] placeholder:self.placeholderImage options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation completion:nil];
}

@end






































