//
//  YPRecommendContentCommonStyleCell.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/12.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  普通 - 170高度  直播 - 167高度  番剧 - 166高度

#import "YPRecommendContentCommonStyleCell.h"
#import "YPRecommendContentCommonStyleLayout.h"
#import "YPRecommendContentViewModel.h"
#import "YPRecommendContentCommonStyleCollectionViewCell.h"
#import "YPRecommendContentLiveStyleCollectionViewCell.h"
#import "YPRecommendContentBangumiStyleCollectionViewCell.h"

@interface YPRecommendContentCommonStyleCell () <UICollectionViewDataSource,UICollectionViewDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation YPRecommendContentCommonStyleCell


static NSString * const CommonStyleCollectionViewCellID = @"YPRecommendContentCommonStyleCollectionViewCell";
static NSString * const LiveStyleCollectionViewCellID = @"YPRecommendContentLiveStyleCollectionViewCell";
static NSString * const BangumiStyleCollectionViewCellID = @"YPRecommendContentBangumiStyleCollectionViewCell";


#pragma mark - Override
- (void)awakeFromNib {
    [super awakeFromNib];
    
    _collectionView.backgroundColor = YPClearColor;
    _collectionView.scrollsToTop = NO;
    
    YPRecommendContentCommonStyleLayout *layout = [[YPRecommendContentCommonStyleLayout alloc] init];
    layout.itemHeight = 170;
    layout.itemCount = 4;
    _collectionView.collectionViewLayout = layout;
    
    // 注册cell
    
    // 普通类型
    UINib *commendNib = [UINib nibWithNibName:NSStringFromClass([YPRecommendContentCommonStyleCollectionViewCell class]) bundle:nil];
    [_collectionView registerNib:commendNib forCellWithReuseIdentifier:CommonStyleCollectionViewCellID];
    
    // 直播类型
    UINib *liveNib = [UINib nibWithNibName:NSStringFromClass([YPRecommendContentLiveStyleCollectionViewCell class]) bundle:nil];
    [_collectionView registerNib:liveNib forCellWithReuseIdentifier:LiveStyleCollectionViewCellID];
    
    // 番剧类型
    UINib *bangumiNib = [UINib nibWithNibName:NSStringFromClass([YPRecommendContentBangumiStyleCollectionViewCell class]) bundle:nil];
    [_collectionView registerNib:bangumiNib forCellWithReuseIdentifier:BangumiStyleCollectionViewCellID];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *defaultCell = [[UICollectionViewCell alloc] init];
    
    if ([_vm.model.type isEqualToString:@"region"] || [_vm.model.type isEqualToString:@"recommend"]) {
        YPRecommendContentCommonStyleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CommonStyleCollectionViewCellID forIndexPath:indexPath];
        cell.model = self.vm.model.body[indexPath.item];
        return cell;
    } else if ([_vm.model.type isEqualToString:@"live"]) {
        YPRecommendContentLiveStyleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LiveStyleCollectionViewCellID forIndexPath:indexPath];
        cell.model = self.vm.model.body[indexPath.item];
        return cell;
    } else if ([_vm.model.type isEqualToString:@"bangumi"]) {
        YPRecommendContentBangumiStyleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BangumiStyleCollectionViewCellID forIndexPath:indexPath];
        cell.model = self.vm.model.body[indexPath.item];
        return cell;
    }
    return defaultCell;
}

- (void)setVm:(YPRecommendContentViewModel *)vm
{
    _vm = vm;
    
    // 拿到数据之后应该刷新collecitonView
    [_collectionView reloadData];
    
}


@end












































