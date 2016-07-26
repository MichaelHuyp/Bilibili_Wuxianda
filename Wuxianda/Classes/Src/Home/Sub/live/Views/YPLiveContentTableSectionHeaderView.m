//
//  YPLiveContentTableSectionHeaderView.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/13.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPLiveContentTableSectionHeaderView.h"
#import "YPRealPartitionModel.h"

@interface YPLiveContentTableSectionHeaderView ()

/** icon */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

/** 标题标签 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/** 详情标签 (除了第一个为进去看看 其他为当前(xxx)个直播，进去看看) */
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (nonatomic, copy) YPLiveContentTableSectionHeaderViewCallBack callBack;

@end

@implementation YPLiveContentTableSectionHeaderView

#pragma mark - Public
+ (instancetype)liveContentTableSectionHeaderViewWithDidTouchCallBack:(YPLiveContentTableSectionHeaderViewCallBack)callBack
{
    YPLiveContentTableSectionHeaderView *view = [YPLiveContentTableSectionHeaderView viewFromXib];
    view.callBack = callBack;
    return view;
}

#pragma mark - Override
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // self
    self.autoresizingMask = UIViewAutoresizingNone;
    self.backgroundColor = YPMainBgColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_callBack) {
        _callBack();
    }
}

#pragma mark - Setter
- (void)setModel:(YPRealPartitionModel *)model
{
    _model = model;
    
    // icon
    [_iconImageView setImageWithURL:[NSURL URLWithString:model.sub_icon.src] placeholder:nil];
    
    // 标题
    _titleLabel.text = model.name;
    
    // 详情
    if ([model.idStr isEqualToString:@"8"]) {
        NSMutableAttributedString *mulStr = [[NSMutableAttributedString alloc] initWithString:@"进去看看"];
        _detailLabel.attributedText = mulStr;
    } else {
        NSString *str = [NSString stringWithFormat:@"当前%@个直播，进去看看",model.count];
        NSMutableAttributedString *mulStr = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSForegroundColorAttributeName] = YPMainColor;
        NSRange range = NSMakeRange(2, model.count.length);
        [mulStr setAttributes:attrs range:range];
        _detailLabel.attributedText = mulStr;
    }
    

}



@end










































