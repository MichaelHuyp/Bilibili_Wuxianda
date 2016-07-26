//
//  YPBangumiDetailEpisodePickerView.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/24.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPBangumiDetailEpisodePickerView.h"
#import "YPBangumiDetailEpisodePickerCollectionViewCell.h"

@interface YPBangumiDetailEpisodePickerView () <UICollectionViewDataSource,UICollectionViewDelegate>

/** 选集(总数) 标签 */
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel;

/** 更新至(xx)话 标签 */
@property (weak, nonatomic) IBOutlet UILabel *updateCountLabel;

/** collectionView */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/** 回调block */
@property (nonatomic, copy) YPBangumiDetailEpisodePickerViewBlock block;

/** collectionView高度的约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colletionViewConstH;



@end

@implementation YPBangumiDetailEpisodePickerView
{
    CGFloat _viewH;
}

static NSString * const BangumiDetailEpisodePickerCollectionViewCellID = @"YPBangumiDetailEpisodePickerCollectionViewCell";

#pragma mark - Public

+ (instancetype)bangumiDetailEpisodePickerViewWithBlock:(YPBangumiDetailEpisodePickerViewBlock)block
{
    YPBangumiDetailEpisodePickerView *view = [YPBangumiDetailEpisodePickerView viewFromXib];
    view.block = block;
    return view;
}

- (void)reloadDataWithTotalCount:(NSUInteger)totalCount updateIndex:(NSUInteger)updateIndex
{
    
    _totalCountLabel.text = [NSString stringWithFormat:@"选集（%lu）",updateIndex];
    _updateCountLabel.text = [NSString stringWithFormat:@"更新 第 %lu 话",updateIndex];
    
    [self.dataSource removeAllObjects];
    
    for (NSUInteger i = updateIndex; i > 0; i--) {
        [self.dataSource addObject:[NSString stringWithFormat:@"%zd",i]];
    }
    
    [_collectionView reloadData];
}

#pragma mark - Lazy
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - Override
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // self
    self.autoresizingMask = UIViewAutoresizingNone;
    
    // layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    // itemSize
    layout.itemSize = CGSizeMake(75, 36);
    
    // 设置布局间距属性
    CGFloat padding = ((YPScreenW - 2 * kAppPadding_8) - 4 * layout.itemSize.width) / 3;
    layout.minimumInteritemSpacing = padding;
    layout.minimumLineSpacing = padding;
    layout.sectionInset = UIEdgeInsetsMake(kAppPadding_16, kAppPadding_8, kAppPadding_8, kAppPadding_16);
    
    // collectionView
    _collectionView.collectionViewLayout = layout;
    
    
    @weakify(self);
    [_collectionView rac_observeKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew observer:self block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        
        @strongify(self);
        
        CGSize size = [change[@"new"] CGSizeValue];
        
        // 记录当前view的高度
        _viewH = 35.5 + size.height + kAppPadding_8;
        
        self.colletionViewConstH.constant = size.height;
        
        [self layoutIfNeeded];
        
    }];
    
    // 注册cell
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([YPBangumiDetailEpisodePickerCollectionViewCell class]) bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:BangumiDetailEpisodePickerCollectionViewCellID];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.height = _viewH;
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YPBangumiDetailEpisodePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BangumiDetailEpisodePickerCollectionViewCellID forIndexPath:indexPath];
    
    cell.episode = self.dataSource[indexPath.item];
    
    return cell;
}



#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_block) {
        _block([self.dataSource[indexPath.item] unsignedIntegerValue]);
    }
}

@end
