//
//  YPLiveContentTableViewCell.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/13.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPLiveContentTableViewCell.h"
#import "YPLivePartitionModel.h"
#import "YPRecommendContentCommonStyleLayout.h"
#import "YPLiveContentCollectionViewCell.h"
#import "YPLiveModel.h"

@interface YPLiveContentTableViewCell () <UICollectionViewDataSource,UICollectionViewDelegate>

/** collectionView */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, copy) YPLiveContentTableViewCellBlock block;

@end

@implementation YPLiveContentTableViewCell

static NSString * const YPLiveContentCollectionViewCellID = @"YPLiveContentCollectionViewCell";

#pragma mark - Public
- (void)liveContentTableViewCellDidSelectedBlock:(YPLiveContentTableViewCellBlock)block
{
    _block = block;
}

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
    CGFloat height = width * 180 / 320 + 47;
    layout.itemHeight = height;
    layout.itemCount = 4;
    _collectionView.collectionViewLayout = layout;
    
    
    // 注册cell
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YPLiveContentCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:YPLiveContentCollectionViewCellID];
    
}

#pragma mark - Setter

- (void)setModel:(YPLivePartitionModel *)model
{
    _model = model;
    
    // 刷新数据源
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item >= 4) return nil;
    
    YPLiveContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YPLiveContentCollectionViewCellID forIndexPath:indexPath];
    
    cell.model = _model.lives[indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YPLiveModel *model = _model.lives[indexPath.item];
    
    if (_block) {
        _block(model);
    }

#if 0
    NSString *path = [[[UIApplication sharedApplication] cachesPath] stringByAppendingPathComponent:@"archive"];
    
    BOOL isfinished = [NSKeyedArchiver archiveRootObject:model toFile:path];
    
    if (isfinished) {
        id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        YPLog(@"%@",obj);
    }
#endif
}




@end





























