//
//  YPBannerCollectionViewCell.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/1.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPBannerCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "YPBannerViewModel.h"

@interface YPBannerCollectionViewCell ()

@property (nonatomic, weak) UIImageView *imageView;

/** 占位图 */
@property (nonatomic, strong) UIImage *placeholderImage;

@end

@implementation YPBannerCollectionViewCell

#pragma mark - Lazy
- (UIImage *)placeholderImage
{
    if (!_placeholderImage) {
        CGFloat width = YPScreenW;
        CGFloat height = 120;
        UIImage *placeholder = [UIImage yp_generateCenterImageWithBgColor:YPMainPlaceHolderBgColor bgImageSize:CGSizeMake(width, height) centerImage:[UIImage imageNamed:@"default_img"]];
        _placeholderImage = placeholder;
    }
    return _placeholderImage;
}

#pragma mark - Override
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self setup];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    [self setup];
    return self;
}

- (void)setup
{
    self.backgroundColor = YPMainBgColor;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    [self.contentView addSubview:imageView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.frame = self.contentView.bounds;
}

#pragma mark - Setter

- (void)setVm:(YPBannerViewModel *)vm
{
    _vm = vm;
    
    YPBannerModel *model = vm.model;
    
    [_imageView setImageWithURL:[NSURL URLWithString:model.image] placeholder:self.placeholderImage options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation completion:nil];
}

@end
















