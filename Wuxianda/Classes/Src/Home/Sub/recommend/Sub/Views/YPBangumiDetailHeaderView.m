//
//  YPBangumiDetailHeaderView.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/21.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPBangumiDetailHeaderView.h"
#import "YPBangumiDetailContentViewModel.h"
#import "YPBangumiDetailEpisodePickerView.h"
#import "YPBangumiDetailContractView.h"
#import "YPBangumiDetailEvaluateView.h"

@interface YPBangumiDetailHeaderView ()

/** 背景图片 */
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
/** 番剧icon */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
/** 返回按钮 */
@property (weak, nonatomic) IBOutlet UIImageView *backArrowImageView;
/** 标题标签 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 是否已完结标签 */
@property (weak, nonatomic) IBOutlet UILabel *isFinishLabel;
/** 详情标签 */
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

/** 分享按钮 */
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
/** 追番按钮 */
@property (weak, nonatomic) IBOutlet UIButton *bangumiBtn;
/** 缓存按钮 */
@property (weak, nonatomic) IBOutlet UIButton *cacheBtn;

/** 剧集选择View */
@property (nonatomic, weak) YPBangumiDetailEpisodePickerView *episodePickerView;

/** 承包View */
@property (nonatomic, weak) YPBangumiDetailContractView *contractView;

/** 简介View */
@property (nonatomic, weak) YPBangumiDetailEvaluateView *evaluateView;

@property (nonatomic, copy) YPBangumiDetailHeaderViewBlock block;

@end

@implementation YPBangumiDetailHeaderView


#pragma mark - Public
+ (instancetype)bangumiDetailHeaderViewWithBlock:(YPBangumiDetailHeaderViewBlock)block
{
    YPBangumiDetailHeaderView *view = [YPBangumiDetailHeaderView viewFromXib];
    view.block = block;
    return view;
}

#pragma mark - Override
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // self
    self.autoresizingMask = UIViewAutoresizingNone;
    
    // icon
    _iconImageView.layer.cornerRadius = 8;
    _iconImageView.layer.borderWidth = 2;
    _iconImageView.layer.borderColor = YPWhiteColor.CGColor;
    _iconImageView.clipsToBounds = YES;
    
    // 分享按钮
    [_shareBtn setImage:[[UIImage imageNamed:@"iphonevideoinfo_share"] imageByTintColor:[UIColor colorWithRed:0.22 green:0.8 blue:0.51 alpha:1]] forState:UIControlStateNormal];
    [_shareBtn setImage:[[UIImage imageNamed:@"iphonevideoinfo_share"] imageByTintColor:[UIColor colorWithRed:0.22 green:0.8 blue:0.51 alpha:1]] forState:UIControlStateHighlighted];
    _shareBtn.imageEdgeInsets = UIEdgeInsetsMake(4, 0, 0, 0);
    
    // 追番按钮
    [_bangumiBtn setImage:[[UIImage imageNamed:@"zhuifan_icon"] imageByTintColor:YPMainColor] forState:UIControlStateNormal];
    [_bangumiBtn setImage:[[UIImage imageNamed:@"zhuifan_icon"] imageByTintColor:YPMainColor] forState:UIControlStateHighlighted];
    _bangumiBtn.imageEdgeInsets = UIEdgeInsetsMake(4, 0, 0, 0);
    
    // 缓存按钮
    [_cacheBtn setImage:[[UIImage imageNamed:@"iphonevideoinfo_dl"] imageByTintColor:[UIColor colorWithRed:0.54 green:0.78 blue:0.98 alpha:1]] forState:UIControlStateNormal];
    [_cacheBtn setImage:[[UIImage imageNamed:@"iphonevideoinfo_dl"] imageByTintColor:[UIColor colorWithRed:0.54 green:0.78 blue:0.98 alpha:1]] forState:UIControlStateHighlighted];
    _cacheBtn.imageEdgeInsets = UIEdgeInsetsMake(4, 0, 0, 0);
    
    
    // 剧集选择View
    @weakify(self);
    YPBangumiDetailEpisodePickerView *episodePickerView = [YPBangumiDetailEpisodePickerView bangumiDetailEpisodePickerViewWithBlock:^(NSUInteger selectEpisodeIndex) {
        @strongify(self);
        if (self.block) {
            self.block(selectEpisodeIndex);
        }
    }];
    _episodePickerView = episodePickerView;
    [self addSubview:episodePickerView];
    
    // 承包View（根据模型中的rank属性判断是否要显示）
    YPBangumiDetailContractView *contractView = [YPBangumiDetailContractView viewFromXib];
    _contractView = contractView;
    [self addSubview:contractView];
    
    // 简介View
    YPBangumiDetailEvaluateView *evaluateView = [YPBangumiDetailEvaluateView viewFromXib];
    _evaluateView = evaluateView;
    [self addSubview:evaluateView];
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整选集View的frame
    _episodePickerView.frame = CGRectMake(0, _iconImageView.bottom + kAppPadding_16, self.width, _episodePickerView.viewH);
    
    // 调整承包view的frame
    _contractView.frame = CGRectMake(0, _episodePickerView.bottom, self.width, _contractView.viewH);
    
    // 调整简介view的frame
    _evaluateView.frame = CGRectMake(0, _contractView.bottom, self.width, _evaluateView.viewH);
    
    // 记录高度
    self.viewH = _evaluateView.bottom;
}



- (void)setVm:(YPBangumiDetailContentViewModel *)vm
{
    _vm = vm;
    
    // 总Model
    YPBangumiDetailContentModel *model = _vm.model;
    
    // rankModel
    YPBangumiDetailRankModel *rankModel = model.rank;
    
    // 顶部背景图片(模糊效果显示)
    @weakify(self);
    [_bgImageView setImageWithURL:[NSURL URLWithString:model.cover] placeholder:nil options:YYWebImageOptionAvoidSetImage completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        @strongify(self);
        self.bgImageView.image = [image imageByBlurLight];
    }];
    
    // icon图片(带圆角白色边框)
    [_iconImageView setImageWithURL:[NSURL URLWithString:model.cover] placeholder:nil options:0 completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        @strongify(self);
        self.iconImageView.image = [image imageByRoundCornerRadius:8 borderWidth:2 borderColor:YPWhiteColor];
    }];
    
    // 番剧标题
    _titleLabel.text = model.title;
    
    // 番剧状态标签
    if ([model.is_finish isEqualToString:@"0"]) {
        _isFinishLabel.text = model.season_title;
    } else {
        _isFinishLabel.text = @"已完结";
    }
    
    // 剧集选择View 刷新剧集选择数据源
    [_episodePickerView reloadDataWithTotalCount:[model.total_count unsignedIntegerValue] updateIndex:[model.newest_ep_index unsignedIntegerValue]];
    
    // 给承包view数据源赋值
    _contractView.rankModel = rankModel;
    
    // 给简介view数据源赋值
    _evaluateView.contentModel = model;
}

@end

























