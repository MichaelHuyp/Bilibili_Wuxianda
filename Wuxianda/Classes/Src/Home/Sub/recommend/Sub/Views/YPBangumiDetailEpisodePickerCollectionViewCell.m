//
//  YPBangumiDetailEpisodePickerCollectionViewCell.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/24.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPBangumiDetailEpisodePickerCollectionViewCell.h"

@interface YPBangumiDetailEpisodePickerCollectionViewCell ()

/** 集数label(用来指示当前为第几集) */
@property (weak, nonatomic) IBOutlet UILabel *episoderLabel;

@end

@implementation YPBangumiDetailEpisodePickerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // self
    self.autoresizingMask = UIViewAutoresizingNone;
    self.layer.cornerRadius =  4;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = YPMainColor.CGColor;
    self.layer.borderWidth = 1;
    
}

- (void)setEpisode:(NSString *)episode
{
    _episode = episode;
    
    _episoderLabel.text = episode;
}

@end
