//
//  YPRecommendContentLargeStyleCollectionViewCell.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/13.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPRecommendContentLargeStyleCollectionViewCell.h"
#import "YPRecommendContentBodyModel.h"


@interface YPRecommendContentLargeStyleCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

/** 占位图 */
@property (nonatomic, strong) UIImage *placeholderImage;


@end

@implementation YPRecommendContentLargeStyleCollectionViewCell

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
    
    _imageView.layer.cornerRadius = 5;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
}

#pragma mark - Setter
- (void)setModel:(YPRecommendContentBodyModel *)model
{
    _model = model;
    
    [_imageView setImageWithURL:[NSURL URLWithString:model.cover] placeholder:self.placeholderImage options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation completion:nil];
}

@end
