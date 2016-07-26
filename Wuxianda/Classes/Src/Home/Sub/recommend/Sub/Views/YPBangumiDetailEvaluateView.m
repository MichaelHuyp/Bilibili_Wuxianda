//
//  YPBangumiDetailEvaluateView.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/7.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPBangumiDetailEvaluateView.h"
#import "YPBangumiDetailContentModel.h"
#import "YPBangumiDetailTagsModel.h"

@interface YPBangumiDetailEvaluateView ()


/** 简介标签 */
@property (weak, nonatomic) IBOutlet UILabel *evaluateLabel;

/** 标签数组 */
@property (nonatomic, strong) NSMutableArray *tagArray;

@end

@implementation YPBangumiDetailEvaluateView
{
    CGFloat _viewH;
}


#pragma mark - Lazy
- (NSMutableArray *)tagArray
{
    if (!_tagArray) {
        _tagArray = [NSMutableArray array];
    }
    return _tagArray;
}



#pragma mark - Override
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // self
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (NSUInteger i = 0; i < self.tagArray.count; i++) {
        
        UIButton *oldTagBtn = nil;
        UIButton *tagBtn = self.tagArray[i];
        
        if (i == 0) {
            tagBtn.top = _evaluateLabel.bottom + kAppPadding_8;
            tagBtn.left = kAppPadding_8;
        } else {
            
            // 拿到之前的tagBtn
            oldTagBtn = self.tagArray[i-1];
            
            if ((oldTagBtn.right + kAppPadding_8 + tagBtn.width) >= self.width) { // 超出边界情况
                tagBtn.top = oldTagBtn.bottom + kAppPadding_8;
                tagBtn.left = kAppPadding_8;
            } else {
                tagBtn.top = oldTagBtn.top;
                tagBtn.left = oldTagBtn.right + kAppPadding_8;
            }
        }
        
        if (i == self.tagArray.count - 1) {
            // 最后一个tag 记录view
            _viewH = tagBtn.bottom + kAppPadding_8;
        }
    }
}

#pragma mark - Setter
- (void)setContentModel:(YPBangumiDetailContentModel *)contentModel
{
    _contentModel = contentModel;
    
    // 简介
    _evaluateLabel.text = contentModel.evaluate;
    
    // 清空tag视图缓存
    for (UIButton *tagBtn in self.tagArray) {
        [tagBtn removeFromSuperview];
    }
    [self.tagArray removeAllObjects];

    
    // 取出tag模型数组的个数
    NSUInteger tagsCount = contentModel.tags.count;
    
    for (NSUInteger i = 0; i < tagsCount; i++) {
        
        // 取出tag模型
        YPBangumiDetailTagsModel *tagModel = contentModel.tags[i];
        
        // 创建tag视图
        UIButton *tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tagBtn setBackgroundColor:YPWhiteColor];
        tagBtn.layer.cornerRadius = 16;
        tagBtn.layer.masksToBounds = YES;
        tagBtn.layer.borderColor = YPMainLineColor.CGColor;
        tagBtn.layer.borderWidth = 1;
        tagBtn.tag = [tagModel.tag_id integerValue];
        [tagBtn setTitle:tagModel.tag_name forState:UIControlStateNormal];
        [tagBtn setTitleColor:YPGrayColor forState:UIControlStateNormal];
        tagBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [tagBtn.titleLabel sizeToFit];
        
        tagBtn.height = 33;
        tagBtn.width = tagBtn.titleLabel.width + 22;
        
        [self addSubview:tagBtn];
        [self.tagArray addObject:tagBtn];
    }
}

@end


















