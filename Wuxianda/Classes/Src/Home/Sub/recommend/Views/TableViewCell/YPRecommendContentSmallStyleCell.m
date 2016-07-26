//
//  YPRecommendContentSmallStyleCell.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/13.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPRecommendContentSmallStyleCell.h"
#import "YPRecommendContentViewModel.h"
#import "YPRecommendContentSmallStyleLayout.h"
#import "YPRecommendContentSmallStyleCollectionViewCell.h"

@interface YPRecommendContentSmallStyleCell ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation YPRecommendContentSmallStyleCell

static NSString * const SmallStyleCollectionViewCellID = @"YPRecommendContentSmallStyleCollectionViewCell";

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _collectionView.backgroundColor = YPClearColor;
    _collectionView.scrollsToTop = NO;
    
    YPRecommendContentSmallStyleLayout *layout = [[YPRecommendContentSmallStyleLayout alloc] init];
    
    _collectionView.collectionViewLayout = layout;
    
    // 注册cell
    
    // 普通类型
    UINib *commendNib = [UINib nibWithNibName:NSStringFromClass([YPRecommendContentSmallStyleCollectionViewCell class]) bundle:nil];
    [_collectionView registerNib:commendNib forCellWithReuseIdentifier:SmallStyleCollectionViewCellID];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.vm.model.body.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    YPRecommendContentSmallStyleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SmallStyleCollectionViewCellID forIndexPath:indexPath];
    
    cell.model = self.vm.model.body[indexPath.item];
    
    return cell;
}

- (void)setVm:(YPRecommendContentViewModel *)vm
{
    _vm = vm;
    
    // 拿到数据之后应该刷新collecitonView
    [self.collectionView reloadData];
}

@end


























