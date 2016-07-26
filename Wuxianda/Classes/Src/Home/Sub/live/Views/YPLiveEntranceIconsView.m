//
//  YPLiveEntranceIconsView.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/12.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPLiveEntranceIconsView.h"
#import "YPLiveEntranceIconsCollectionViewCell.h"
#import "YPLiveEntranceIconModel.h"

@interface YPLiveEntranceIconsView () <UICollectionViewDataSource,UICollectionViewDelegate>

/** 入口图标视图 */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

/** 底部toolBar */
@property (weak, nonatomic) IBOutlet UIView *bottomToolBar;

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *entranceIconDataSource;

/** 关注主播按钮 */
@property (weak, nonatomic) IBOutlet UIButton *attentionAuthorBtn;

/** 直播中心按钮 */
@property (weak, nonatomic) IBOutlet UIButton *liveCenterBtn;

/** 搜索直播按钮 */
@property (weak, nonatomic) IBOutlet UIButton *searchLiveBtn;

@property (nonatomic, copy) YPLiveEntranceIconsViewBlock block;

@end

@implementation YPLiveEntranceIconsView

static NSString * const cellID = @"YPLiveEntranceIconsCollectionViewCell";

#pragma mark - Lazy
- (NSMutableArray *)entranceIconDataSource
{
    if (!_entranceIconDataSource) {
        _entranceIconDataSource = [NSMutableArray array];
    }
    return _entranceIconDataSource;
}

#pragma mark - Public
+ (instancetype)liveEntranceIconsViewWithBlock:(YPLiveEntranceIconsViewBlock)block
{
    YPLiveEntranceIconsView *view = [YPLiveEntranceIconsView viewFromXib];
    view.block = block;
    return view;
}

#pragma mark - Override

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // self
    self.autoresizingMask = UIViewAutoresizingNone;
    self.backgroundColor = YPMainBgColor;
    
    // bottomToolBar
    _bottomToolBar.layer.cornerRadius = 4;
    _bottomToolBar.layer.masksToBounds = YES;
    
    // collectionView
    _collectionView.backgroundColor = YPMainBgColor;
    _collectionView.scrollsToTop = NO;
    
    // layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemW = YPScreenW / 4;
    CGFloat itemH = itemW;
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    _collectionView.collectionViewLayout = layout;
    
    // register cell
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YPLiveEntranceIconsCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:cellID];
    
    // Button
    @weakify(self);
    [[_attentionAuthorBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.block) {
            self.block(YPLiveEntranceIconsViewAreaTypeAttentionAuthor);
        }
    }];
    
    [[_liveCenterBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.block) {
            self.block(YPLiveEntranceIconsViewAreaTypeLiveCenter);
        }
    }];
    
    [[_searchLiveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.block) {
            self.block(YPLiveEntranceIconsViewAreaTypeSearchLive);
        }
    }];
}

#pragma mark - Setter
- (void)setEntranceIconArray:(NSArray *)entranceIconArray
{
    _entranceIconArray = entranceIconArray;
    
    [self.entranceIconDataSource removeAllObjects];
    
    [self.entranceIconDataSource addObjectsFromArray:entranceIconArray];
    
    YPLiveEntranceIconModel *model1 = [[YPLiveEntranceIconModel alloc] init];
    YPRealEntranceIconModel *srcModel1 = [[YPRealEntranceIconModel alloc] init];
    model1.idStr = @"10086";
    model1.name = @"全部分类";
    srcModel1.src = @"live_partitionEntrance-1";
    model1.entrance_icon = srcModel1;
    
    YPLiveEntranceIconModel *model2 = [[YPLiveEntranceIconModel alloc] init];
    YPRealEntranceIconModel *srcModel2 = [[YPRealEntranceIconModel alloc] init];
    model2.idStr = @"10087";
    model2.name = @"全部直播";
    srcModel2.src = @"live_partitionEntrance0";
    model2.entrance_icon = srcModel2;
    
    [self.entranceIconDataSource addObject:model1];
    [self.entranceIconDataSource addObject:model2];
    
    // 刷新数据源
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.entranceIconDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YPLiveEntranceIconsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    cell.model = self.entranceIconDataSource[indexPath.item];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YPLiveEntranceIconModel *model = self.entranceIconDataSource[indexPath.item];
    
    if (self.block) {
        self.block([model.idStr integerValue]);
    }
}


@end









































