//
//  YPRecommendContentCommonStyleCollectionViewCell.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/13.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPRecommendContentCommonStyleCollectionViewCell.h"
#import "YPRecommendContentBodyModel.h"

@interface YPRecommendContentCommonStyleCollectionViewCell ()

/** 图片imageView */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/** 标题Label */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 播放数Label */
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
/** 弹幕数Label */
@property (weak, nonatomic) IBOutlet UILabel *danmukuCountLabel;

/** 占位图 */
@property (nonatomic, strong) UIImage *placeholderImage;

@end

@implementation YPRecommendContentCommonStyleCollectionViewCell

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
    _playCountLabel.text = model.play;
    _danmukuCountLabel.text = model.danmaku;
    
    [_imageView setImageWithURL:[NSURL URLWithString:model.cover] placeholder:self.placeholderImage options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation completion:nil];
}


@end



















