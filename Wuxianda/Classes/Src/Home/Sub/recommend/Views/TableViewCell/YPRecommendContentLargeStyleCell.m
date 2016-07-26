//
//  YPRecommendContentLargeStyleCell.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/13.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPRecommendContentLargeStyleCell.h"
#import "YPRecommendContentViewModel.h"
#import "YPRecommendContentLargeStyleLayout.h"
#import "YPRecommendContentLargeStyleCollectionViewCell.h"

@interface YPRecommendContentLargeStyleCell () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation YPRecommendContentLargeStyleCell

static NSString * const LargeStyleCollectionViewCellID = @"YPRecommendContentLargeStyleCollectionViewCell";

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _collectionView.backgroundColor = YPClearColor;
    _collectionView.scrollsToTop = NO;
    
    YPRecommendContentLargeStyleLayout *layout = [[YPRecommendContentLargeStyleLayout alloc] init];
    _collectionView.collectionViewLayout = layout;
    
    // 注册cell
    
    // 普通类型
    UINib *commendNib = [UINib nibWithNibName:NSStringFromClass([YPRecommendContentLargeStyleCollectionViewCell class]) bundle:nil];
    [_collectionView registerNib:commendNib forCellWithReuseIdentifier:LargeStyleCollectionViewCellID];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YPRecommendContentLargeStyleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LargeStyleCollectionViewCellID forIndexPath:indexPath];
    
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
