//
//  YPBangumiEndAnimationTableViewCell.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/20.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPBangumiEndAnimationTableViewCell.h"
#import "YPBangumiEndAnimationCollectionViewCell.h"
#import "YPRecommendContentSmallStyleLayout.h"

@interface YPBangumiEndAnimationTableViewCell ()


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation YPBangumiEndAnimationTableViewCell

static NSString * const YPBangumiEndAnimationCollectionViewCellID = @"YPBangumiEndAnimationCollectionViewCell";

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // self
    self.autoresizingMask = UIViewAutoresizingNone;
    
    // collectionView
    _collectionView.backgroundColor = YPMainBgColor;
    _collectionView.scrollsToTop = NO;
    
    YPRecommendContentSmallStyleLayout *layout = [[YPRecommendContentSmallStyleLayout alloc] init];
    _collectionView.collectionViewLayout = layout;
    
    // 注册cell
    
    // 普通类型
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YPBangumiEndAnimationCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:YPBangumiEndAnimationCollectionViewCellID];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modelArr.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YPBangumiEndAnimationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YPBangumiEndAnimationCollectionViewCellID forIndexPath:indexPath];
    
    cell.model = self.modelArr[indexPath.item];
    
    return cell;
}

#pragma mark - Setter
- (void)setModelArr:(NSArray *)modelArr
{
    _modelArr = modelArr;
    
    [_collectionView reloadData];
}


@end
