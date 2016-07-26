//
//  YPLiveEntranceIconsCollectionViewCell.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/12.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPLiveEntranceIconsCollectionViewCell.h"
#import "YPVerticalButton.h"
#import "YPLiveEntranceIconModel.h"

@interface YPLiveEntranceIconsCollectionViewCell ()

@property (weak, nonatomic) IBOutlet YPVerticalButton *button;

@end

@implementation YPLiveEntranceIconsCollectionViewCell

#pragma mark - Override
- (void)awakeFromNib {
    [super awakeFromNib];
    
    // self
    self.autoresizingMask = UIViewAutoresizingNone;
}

#pragma mark - Setter
- (void)setModel:(YPLiveEntranceIconModel *)model
{
    _model = model;
    
    NSURL *url = [NSURL URLWithString:model.entrance_icon.src];
    NSString *scheme = [[url scheme] lowercaseString];
    if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]) {
        [_button setImageWithURL:[NSURL URLWithString:model.entrance_icon.src] forState:UIControlStateNormal placeholder:nil options:0 completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            
            UIImage *targetImage = [image imageByResizeToSize:CGSizeMake(40, 40) contentMode:UIViewContentModeScaleAspectFit];
            
            [_button setImage:[targetImage imageByRoundCornerRadius:targetImage.size.width * 0.5] forState:UIControlStateNormal];
        }];
    } else {
        [_button setImage:[UIImage imageNamed:model.entrance_icon.src] forState:UIControlStateNormal];
    }
    

    [_button setTitle:model.name forState:UIControlStateNormal];
}

@end
