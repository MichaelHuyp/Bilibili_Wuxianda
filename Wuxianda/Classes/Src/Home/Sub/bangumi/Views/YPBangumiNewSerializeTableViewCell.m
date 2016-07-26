//
//  YPBangumiNewSerializeTableViewCell.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/20.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPBangumiNewSerializeTableViewCell.h"
#import "YPBangumiHeaderContentLatestUpdateModel.h"
#import "YPBangumiNewSerializeCollectionViewCell.h"
#import "YPRecommendContentCommonStyleLayout.h"

@interface YPBangumiNewSerializeTableViewCell () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation YPBangumiNewSerializeTableViewCell

static NSString * const YPBangumiNewSerializeCollectionViewCellID = @"YPBangumiNewSerializeCollectionViewCell";

#pragma mark - Override
- (void)awakeFromNib {
    [super awakeFromNib];
    
    // self
    self.autoresizingMask = UIViewAutoresizingNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = YPMainBgColor;
    
    /**** collectionView ****/
    _collectionView.scrollsToTop = NO;
    _collectionView.backgroundColor = YPMainBgColor;
    
    // layout
    YPRecommendContentCommonStyleLayout *layout = [[YPRecommendContentCommonStyleLayout alloc] init];
    CGFloat width = (YPScreenW - 3 * kAppPadding_8) * 0.5;
    CGFloat height = width * 180 / 320 + 46;
    layout.itemHeight = height;
    layout.itemCount = 6;
    _collectionView.collectionViewLayout = layout;
    
    // register cell
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YPBangumiNewSerializeCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:YPBangumiNewSerializeCollectionViewCellID];
}

#pragma mark - Setter
- (void)setModel:(YPBangumiHeaderContentLatestUpdateModel *)model
{
    _model = model;
    
    // 刷新数据源
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item >= 6) return nil;
    
    YPBangumiNewSerializeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YPBangumiNewSerializeCollectionViewCellID forIndexPath:indexPath];
    cell.model = self.model.list[indexPath.item];
    return cell;
}

@end








































