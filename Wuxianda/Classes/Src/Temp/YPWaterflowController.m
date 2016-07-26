//
//  YPWaterflowController.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/8.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPWaterflowController.h"
#import "YPWaterflowLayout.h"
#import "XMGShop.h"
#import "MJRefresh.h"
#import "XMGShopCell.h"

@interface YPWaterflowController () <UICollectionViewDataSource, YPWaterflowLayoutDelegate>

@property (nonatomic, strong) NSMutableArray *shops;

@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation YPWaterflowController

- (NSMutableArray *)shops
{
    if (!_shops) {
        _shops = [NSMutableArray array];
    }
    return _shops;
}

static NSString * const XMGShopId = @"shop";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
}

#pragma mark - UI
- (void)createUI
{
    // self
    self.view.autoresizingMask = UIViewAutoresizingNone;
    
    // 创建布局
    YPWaterflowLayout *layout = [[YPWaterflowLayout alloc] init];
    layout.delegate = self;
    
    // 创建CollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:YPScreenBounds collectionViewLayout:layout];
    _collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.backgroundColor = YPWhiteColor;
    [self.view addSubview:collectionView];
    
    // 注册
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMGShopCell class]) bundle:nil] forCellWithReuseIdentifier:XMGShopId];
    
    // refresh
    @weakify(self);
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        
        @weakify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            @strongify(self);
            
            NSArray *shops = [XMGShop mj_objectArrayWithFilename:@"1.plist"];
            [self.shops removeAllObjects];
            [self.shops addObjectsFromArray:shops];
            
            // 刷新数据
            [self.collectionView reloadData];
            
            [self.collectionView.mj_header endRefreshing];
        });
    }];
    [self.collectionView.mj_header beginRefreshing];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        
        @weakify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            @strongify(self);
            
            NSArray *shops = [XMGShop mj_objectArrayWithFilename:@"1.plist"];
            [self.shops addObjectsFromArray:shops];
            
            // 刷新数据
            [self.collectionView reloadData];
            
            [self.collectionView.mj_footer endRefreshing];
        });
    }];
    self.collectionView.mj_footer.automaticallyHidden = YES;
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shops.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XMGShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XMGShopId forIndexPath:indexPath];
    
    cell.shop = self.shops[indexPath.item];
    
    return cell;
}

#pragma mark - YPWaterflowLayoutDelegate
- (CGFloat)waterflowLayout:(YPWaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth
{
    XMGShop *shop = self.shops[index];
    
    return itemWidth * shop.h / shop.w;
}

- (CGFloat)rowMarginInWaterflowLayout:(YPWaterflowLayout *)waterflowLayout
{
    return 10;
}

- (NSUInteger)columnCountInWaterflowLayout:(YPWaterflowLayout *)waterflowLayout
{
    return 4;
}



@end

















































