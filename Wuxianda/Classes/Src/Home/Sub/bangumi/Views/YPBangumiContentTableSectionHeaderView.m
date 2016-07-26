//
//  YPBangumiContentTableSectionHeaderView.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/21.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPBangumiContentTableSectionHeaderView.h"

@interface YPBangumiContentTableSectionHeaderView ()

// icon
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

// 标题标签
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

// 详情标签
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end

@implementation YPBangumiContentTableSectionHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // self
    self.backgroundColor = YPMainBgColor;
    self.autoresizingMask = UIViewAutoresizingNone;
}

#pragma mark - Public
+ (instancetype)bangumiContentTableSectionHeaderViewWithIcon:(UIImage *)iconImage title:(NSString *)title isShowRightDetailLabel:(BOOL)show updateCount:(NSString *)updateCount
{
    YPBangumiContentTableSectionHeaderView *view = [YPBangumiContentTableSectionHeaderView viewFromXib];
    view.iconImageView.image = iconImage;
    view.titleLabel.text = title;
    
    if (show) {
        view.detailLabel.hidden = NO;
        view.arrowImageView.hidden = NO;
        
        if ([updateCount isNotBlank]) {
            NSString *str = [NSString stringWithFormat:@"今日更新 %@",updateCount];
            NSMutableAttributedString *mulStr = [[NSMutableAttributedString alloc] initWithString:str];
            NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
            attrs[NSForegroundColorAttributeName] = YPMainColor;
            NSRange range = NSMakeRange(5, updateCount.length);
            [mulStr setAttributes:attrs range:range];
            view.detailLabel.attributedText = mulStr;
        } else {
            NSMutableAttributedString *mulStr = [[NSMutableAttributedString alloc] initWithString:@"进去看看"];
            view.detailLabel.attributedText = mulStr;
        }
    } else {
        view.detailLabel.hidden = YES;
        view.arrowImageView.hidden = YES;
    }
    
    return view;

}

@end
