//
//  YPRecommendContentSmallStyleCollectionViewCell.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/13.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPRecommendContentSmallStyleCollectionViewCell.h"
#import "YPRecommendContentBodyModel.h"
#import "UIView+YPLayer.h"

@interface YPRecommendContentSmallStyleCollectionViewCell ()
/** 封面 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/** 电视剧名字标签 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 详情标签 （更新到第xx话）*/
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

/** 占位图 */
@property (nonatomic, strong) UIImage *placeholderImage;

@end

@implementation YPRecommendContentSmallStyleCollectionViewCell

#pragma mark - Lazy
- (UIImage *)placeholderImage
{
    if (!_placeholderImage) {
        CGFloat margin = 8;
        CGFloat width = YPScreenW - 2 * margin;
        CGFloat height = 120;
        UIImage *placeholder = [UIImage yp_generateCenterImageWithBgColor:YPMainPlaceHolderBgColor bgImageSize:CGSizeMake(width, height) centerImage:[UIImage imageNamed:@"default_img"]];
        _placeholderImage = placeholder;
    }
    return _placeholderImage;
}

#pragma mark - Override
- (void)awakeFromNib {
    [super awakeFromNib];
    
    _imageView.layerCornerRadius= 8;
}

#pragma mark - Setter
- (void)setModel:(YPRecommendContentBodyModel *)model
{
    _model = model;
    
    _titleLabel.text = model.title;
    _detailLabel.text = [NSString stringWithFormat:@"更新到第%@话", model.index];
    
    
    [_imageView setImageWithURL:[NSURL URLWithString:model.cover] placeholder:self.placeholderImage options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation completion:nil];
}

@end
