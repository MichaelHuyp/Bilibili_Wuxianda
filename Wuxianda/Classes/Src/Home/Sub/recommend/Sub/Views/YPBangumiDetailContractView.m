//
//  YPBangumiDetailContractView.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/7.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  

#import "YPBangumiDetailContractView.h"
#import "YPBangumiDetailRankModel.h"
#import "YPRankListModel.h"

#define kContractBorderColor [UIColor colorWithRed:1 green:0.76 blue:0 alpha:1]

@interface YPBangumiDetailContractView ()


/** 承包总人数标签(已有xx人承包了这部番) */
@property (weak, nonatomic) IBOutlet UILabel *totalContractLabel;

/** 七天内承包人数标签 */
@property (weak, nonatomic) UILabel *weekContractLabel;

/** 查看榜单按钮 */
@property (weak, nonatomic) IBOutlet UIButton *seeRankBtn;

/** 承包按钮 */
@property (weak, nonatomic) IBOutlet UIButton *contractBtn;

/** 容器视图 */
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, strong) NSMutableArray *iconArray;

/** 分割线 */
@property (weak, nonatomic) IBOutlet UIView *line_1;

/** 容器视图高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewConstH;

@end

@implementation YPBangumiDetailContractView
{
    CGFloat _viewH;
}

- (NSMutableArray *)iconArray
{
    if (!_iconArray) {
        _iconArray = [NSMutableArray array];
    }
    return _iconArray;
}



#pragma mark - Override
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // self
    self.autoresizingMask = UIViewAutoresizingNone;
    
    
    // contentView
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.borderColor = [UIColor colorWithRed:1 green:0.76 blue:0 alpha:1].CGColor;
    
    // 查看榜单按钮
    self.seeRankBtn.layer.borderWidth = 1;
    self.seeRankBtn.layer.borderColor = YPLightLineColor.CGColor;
    
    // 七天内承包标签
    UILabel *weekContractLabel = [[UILabel alloc] init];
    _weekContractLabel = weekContractLabel;
    [self.contentView addSubview:weekContractLabel];
    weekContractLabel.font = [UIFont systemFontOfSize:14];
    weekContractLabel.textColor = YPGrayColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 七日内承包标签位置调整
    if (self.iconArray.count) {
        // 取出最后一个icon
        UIImageView *lastIcon = [self.iconArray lastObject];
        
        // 调整七天内承包标签的位置
        _weekContractLabel.centerY = lastIcon.centerY;
        _weekContractLabel.left = lastIcon.right + kAppPadding_8;
    }
    
    // 修改容器视图高度
    _contentViewConstH.constant = _seeRankBtn.bottom + kAppPadding_16;
    [self layoutIfNeeded];
    
    // 记录view高度
    _viewH = _contentView.bottom + kAppPadding_8;
}

#pragma mark - Setter
- (void)setRankModel:(YPBangumiDetailRankModel *)rankModel
{
    _rankModel = rankModel;
    
    // 总承包数标签
    _totalContractLabel.text = [NSString stringWithFormat:@"已有%@人承包了这部番",rankModel.total_bp_count];
    
    // 七天内承包标签
    _weekContractLabel.text = [NSString stringWithFormat:@"等%@人七日内承包",rankModel.week_bp_count];
    [_weekContractLabel sizeToFit];
    
    // 取出icon List个数
    NSUInteger iconListCount = rankModel.list.count;
    
    // 清空icon以及 icon数组
    for (UIImageView *imageView in self.iconArray) {
        [imageView removeFromSuperview];
    }
    [self.iconArray removeAllObjects];
 
    
    for (int i = 0; i < iconListCount; i++) {
        UIImageView *iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconImageView];
        [self.iconArray addObject:iconImageView];
        iconImageView.size = CGSizeMake(22, 22);
        
        // 布局
        iconImageView.centerY = _seeRankBtn.centerY;
        iconImageView.left = kAppPadding_12 + i * (iconImageView.width - 2);
        
        YPRankListModel *listModel = rankModel.list[i];
        
        
        __block UIImageView *tempImageView = iconImageView;
        
        [iconImageView setImageWithURL:[NSURL URLWithString:listModel.face] placeholder:nil options:0 completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            
            tempImageView.image = [[image imageByResizeToSize:tempImageView.size contentMode:UIViewContentModeScaleAspectFill] imageByRoundCornerRadius:tempImageView.size.width * 0.5];
        }];
    }
    
    for (UIImageView *imageView in self.iconArray) {
        [imageView.superview sendSubviewToBack:imageView];
    }
    


    
}

@end





































