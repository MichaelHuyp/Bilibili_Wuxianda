//
//  YPLiveViewController.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/8.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPLiveViewController.h"
#import "YPLiveContentViewModel.h"
#import "YPCycleBanner.h"
#import "YPLiveBannerModel.h"
#import "YPLiveContentTableHeaderView.h"
#import "YPLiveContentTableViewCell.h"
#import "YPLiveContentTableSectionHeaderView.h"
#import "YPLivePartitionModel.h"
#import "YPLiveContentTableSectionFooterView.h"
#import "YPBilibiliNormalRefresh.h"
#import "YPLiveDetailViewController.h"
//#import "YZDisplayViewHeader.h"

@interface YPLiveViewController () <UITableViewDataSource,UITableViewDelegate,YPLiveContentTableHeaderDelegate>

/** 直播内容VM */
@property (nonatomic, strong) YPLiveContentViewModel *liveContentVM;

/** 内容视图(TableView) */
@property (nonatomic, weak) UITableView *contentTableView;

/** 头部视图 */
@property (nonatomic, weak) YPLiveContentTableHeaderView *tableHeaderView;

/** 记录上次选中的tabbar索引 */
@property (nonatomic, assign) NSInteger lastSelectedTabBarIndex;



@end

@implementation YPLiveViewController

static NSString * const YPLiveContentTableViewCellID = @"YPLiveContentTableViewCell";

#pragma mark - Lazy

- (YPLiveContentViewModel *)liveContentVM
{
    if (!_liveContentVM) {
        _liveContentVM = [[YPLiveContentViewModel alloc] init];
    }
    return _liveContentVM;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // UI
    [self createUI];
    
    // Data
    [self loadData];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _contentTableView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
}

- (void)dealloc
{
    [YPNotificationCenter removeObserver:self];
}


#pragma mark - UI

- (void)createUI
{
    
    // self
    self.view.backgroundColor = YPMainBgColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.autoresizingMask = UIViewAutoresizingNone;
    
    // 内容视图
    UITableView *contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _contentTableView = contentTableView;
    contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    contentTableView.backgroundColor = YPMainBgColor;
    contentTableView.dataSource = self;
    contentTableView.delegate = self;
    contentTableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    contentTableView.scrollIndicatorInsets = contentTableView.contentInset;
    contentTableView.rowHeight = 306;
    [self.view addSubview:contentTableView];
    
    // 添加下拉刷新控件
    @weakify(self);
    contentTableView.mj_header = [YPBilibiliNormalRefresh headerWithRefreshingBlock:^{
        // 刷新数据
        @strongify(self);
        [self loadData];
    }];
    
#if 0
    // 订阅YZDisplayViewClickOrScrollDidFinshNote通知决定是否刷新
    [[YPNotificationCenter rac_addObserverForName:YZDisplayViewClickOrScrollDidFinshNote object:nil] subscribeNext:^(NSNotification *x) {
        @strongify(self);
        if ([x.object isKindOfClass:[self class]]) {
            [self.contentTableView.mj_header beginRefreshing];
        }
    }];
#endif
    
    // 订阅轮播图开始滑动以及结束滑动的通知改变首页内容视图是否可以滑动
    
    [[YPNotificationCenter rac_addObserverForName:kCycleBannerWillBeginDraggingNotification object:nil] subscribeNext:^(id x) {
        @strongify(self);
        self.contentTableView.scrollEnabled = NO;
    }];
    
    [[YPNotificationCenter rac_addObserverForName:kCycleBannerDidEndDeceleratingNotification object:nil] subscribeNext:^(id x) {
        @strongify(self);
        self.contentTableView.scrollEnabled = YES;
    }];
    
    // 监听tabbar点击的通知
    [[YPNotificationCenter rac_addObserverForName:YPTabBarDidSelectNotification object:nil] subscribeNext:^(id x) {
        @strongify(self);
        
        // 如果是连续选中2此，直接返回
        if (self.lastSelectedTabBarIndex == self.tabBarController.selectedIndex && self.view.isShowingOnKeyWindow) {
            [self.contentTableView.mj_header beginRefreshing];
        }
        
        // 记录这次选中的索引
        self.lastSelectedTabBarIndex = self.tabBarController.selectedIndex;
    }];
    
    // 注册cell
    [contentTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YPLiveContentTableViewCell class]) bundle:nil] forCellReuseIdentifier:YPLiveContentTableViewCellID];
    
    // headerView
    YPLiveContentTableHeaderView *tableHeaderView = [YPLiveContentTableHeaderView liveContentTableHeaderView];
    _tableHeaderView = tableHeaderView;
    _tableHeaderView.frame = CGRectMake(0, 0, YPScreenW, 364.5);
    _tableHeaderView.myDelegate = self;
    contentTableView.tableHeaderView = tableHeaderView;
    
    [_tableHeaderView rac_observeKeyPath:@"viewH" options:NSKeyValueObservingOptionNew observer:self block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        
        @strongify(self);
        
        CGFloat new = [change[@"new"] floatValue];
        
        self.tableHeaderView.frame = CGRectMake(0, 0, YPScreenW, new);
        self.contentTableView.tableHeaderView = self.tableHeaderView;
    }];
}

#pragma mark - Data

- (void)loadData
{
    // 从"网络"加载直播内容数据
    [self.liveContentVM loadDataArrFromNetwork];
    
    @weakify(self);
    [[self.liveContentVM.requestCommand execute:nil] subscribeNext:^(id x) {
        
        @strongify(self);
        
        // 给头部视图VM赋值
        self.tableHeaderView.vm = self.liveContentVM;
        
        // 刷新tableView数据源
        [self.contentTableView reloadData];
        
        // 结束刷新
        [_contentTableView.mj_header endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.liveContentVM.model.partitions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YPLiveContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YPLiveContentTableViewCellID];

    cell.model = self.liveContentVM.model.partitions[indexPath.section];
    
    @weakify(self);
    [cell liveContentTableViewCellDidSelectedBlock:^(YPLiveModel *selectedLiveModel) {
        @strongify(self);
        YPLiveDetailViewController *detailVc = [YPLiveDetailViewController controller];
        detailVc.model = selectedLiveModel;
        [self.parentViewController.navigationController pushViewController:detailVc animated:YES];
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    YPLivePartitionModel *model = self.liveContentVM.model.partitions[section];
    YPLiveContentTableSectionHeaderView *view = [YPLiveContentTableSectionHeaderView liveContentTableSectionHeaderViewWithDidTouchCallBack:^{
        YPLog(@"点击了%@模块",model.partition.name);
    }];
    view.model = model.partition;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    YPLivePartitionModel *model = self.liveContentVM.model.partitions[section];
    YPLiveContentTableSectionFooterView *view = [YPLiveContentTableSectionFooterView liveContentTableSectionFooterViewWithSeeMoreCallBack:^{
        YPLog(@"点击了%@模块的查看更多",model.partition.name);
    } refreshCallBack:^{
        YPLog(@"点击了%@模块的刷新动态",model.partition.name);
    }];
    return view;
}

#pragma mark - YPLiveContentTableHeaderDelegate

- (void)liveContentTableHeaderView:(YPLiveContentTableHeaderView *)liveContentTableHeaderView selectedAreaID:(YPLiveEntranceIconsViewAreaType)areaID
{
    YPLog(@"点击了入口图标索引 %ld",areaID);
}


- (void)liveContentTableHeaderView:(YPLiveContentTableHeaderView *)liveContentTableHeaderView didSelectedBannerIndex:(NSUInteger)index
{
    YPLog(@"点击了轮播索引 %lu",index);
}

@end










































