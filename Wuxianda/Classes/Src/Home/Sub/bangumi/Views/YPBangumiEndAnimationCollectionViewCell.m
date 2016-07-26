//
//  YPBangumiEndAnimationCollectionViewCell.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/20.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPBangumiEndAnimationCollectionViewCell.h"
#import "YPBangumiCommonModel.h"
#import "UIView+YPLayer.h"

@interface YPBangumiEndAnimationCollectionViewCell ()
/** 封面 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/** 电视剧名字标签 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 详情标签 （xx话全）*/
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

/** 占位图 */
@property (nonatomic, strong) UIImage *placeholderImage;

@end

@implementation YPBangumiEndAnimationCollectionViewCell

#pragma mark - Lazy
- (UIImage *)placeholderImage
{
    if (!_placeholderImage) {
        CGFloat width = YPScreenW - 2 * kAppPadding_8;
        CGFloat height = 120;
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
    
    
    // imageView
    _imageView.layerCornerRadius = 8;
}

#pragma mark - Setter

- (void)setModel:(YPBangumiCommonModel *)model
{
    _model = model;
    
    // 封面
    [_imageView setImageWithURL:[NSURL URLWithString:model.cover] placeholder:self.placeholderImage options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    
    _titleLabel.text = model.title;
    _detailLabel.text = [NSString stringWithFormat:@"%@话全", model.total_count];
}

@end





























