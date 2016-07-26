//
//  YPBangumiNewSerializeCollectionViewCell.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/20.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPBangumiNewSerializeCollectionViewCell.h"
#import "YPBangumiCommonModel.h"

@interface YPBangumiNewSerializeCollectionViewCell ()

/** 封面 */
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

/** 封面高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverImageViewHeightCons;

/** 标题标签 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/** 详情标签 */
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

/** xx人在看标签 */
@property (weak, nonatomic) IBOutlet UILabel *liveCountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *watchTagImageView;

@property (nonatomic, strong) UIImage *contentImageViewPlaceholderImage;

@end

@implementation YPBangumiNewSerializeCollectionViewCell

#pragma mark - Lazy

- (UIImage *)contentImageViewPlaceholderImage
{
    if (!_contentImageViewPlaceholderImage) {
        CGFloat width = (YPScreenW - 3 * kAppPadding_8) * 0.5 - 5;
        CGFloat height = width * 180 / 320;
        UIImage *placeholder = [UIImage yp_generateCenterImageWithBgColor:YPMainPlaceHolderBgColor bgImageSize:CGSizeMake(width, height) centerImage:[UIImage imageNamed:@"default_img"]];
        _contentImageViewPlaceholderImage = placeholder;
    }
    return _contentImageViewPlaceholderImage;
}

#pragma mark - Override
- (void)awakeFromNib {
    [super awakeFromNib];
    
    // self
    self.autoresizingMask = UIViewAutoresizingNone;
    self.backgroundColor = YPMainBgColor;
}

#pragma mark - Setter
- (void)setModel:(YPBangumiCommonModel *)model
{
    _model = model;
    
    if ([model.watchingCount integerValue] == 0) {
        _liveCountLabel.hidden = YES;
        _watchTagImageView.hidden = YES;
    } else {
        _liveCountLabel.hidden = NO;
        _watchTagImageView.hidden = NO;
        _liveCountLabel.text = [NSString stringWithFormat:@"%@人在看", model.watchingCount];
    }
    
    // 封面
    CGFloat width = (YPScreenW - 3 * kAppPadding_8) * 0.5 - 5;
    CGFloat height = width * 180 / 320;
    @weakify(self);
    [_coverImageView setImageWithURL:[NSURL URLWithString:model.cover] placeholder:[self.contentImageViewPlaceholderImage imageByRoundCornerRadius:4] options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        UIImage *targetImage = [image imageByResizeToSize:CGSizeMake(width, height) contentMode:UIViewContentModeScaleAspectFill];
        @strongify(self);
        self.coverImageView.image = [targetImage imageByRoundCornerRadius:4];
    }];
    _coverImageViewHeightCons.constant = height;
    [self layoutIfNeeded];
    
    // 标题
    _titleLabel.text = model.title;
}

@end
