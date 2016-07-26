//
//  YPBangumiViewController.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/20.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPBangumiViewController.h"
#import "YPBangumiHeaderContentViewModel.h"
#import "YPBilibiliNormalRefresh.h"
#import "YPCycleBanner.h"
#import "YPBangumiContentTableHeaderView.h"
#import "YPBangumiNewSerializeTableViewCell.h"
#import "YPBangumiEndAnimationTableViewCell.h"
#import "YPBangumiContentViewModel.h"
#import "YPBangumiRecommondTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "YPBangumiContentTableSectionHeaderView.h"

@interface YPBangumiViewController () <UITableViewDelegate,UITableViewDataSource>

/** 内容视图(TableView) */
@property (nonatomic, weak) UITableView *contentTableView;

/** 头部视图VM */
@property (nonatomic, strong) YPBangumiHeaderContentViewModel *headerVM;

/** 底部数据VM */
@property (nonatomic, strong) YPBangumiContentViewModel *bottomVM;

/** 记录上次选中的tabbar索引 */
@property (nonatomic, assign) NSInteger lastSelectedTabBarIndex;

/** 头部视图 */
@property (nonatomic, weak) YPBangumiContentTableHeaderView *tableHeaderView;

@end

@implementation YPBangumiViewController

static NSString * const YPBangumiNewSerializeTableViewCellID = @"YPBangumiNewSerializeTableViewCell";
static NSString * const YPBangumiEndAnimationTableViewCellID = @"YPBangumiEndAnimationTableViewCell";
static NSString * const YPBangumiRecommondTableViewCellID = @"YPBangumiRecommondTableViewCell";

#pragma mark - Lazy
- (YPBangumiHeaderContentViewModel *)headerVM
{
    if (!_headerVM) {
        _headerVM = [[YPBangumiHeaderContentViewModel alloc] init];
    }
    return _headerVM;
}

- (YPBangumiContentViewModel *)bottomVM
{
    if (!_bottomVM) {
        _bottomVM = [[YPBangumiContentViewModel alloc] init];
    }
    return _bottomVM;
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
    [self.view addSubview:contentTableView];
    
    // 添加下拉刷新控件
    @weakify(self);
    contentTableView.mj_header = [YPBilibiliNormalRefresh headerWithRefreshingBlock:^{
        // 刷新数据
        @strongify(self);
        [self loadData];
    }];
    
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
    [contentTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YPBangumiNewSerializeTableViewCell class]) bundle:nil] forCellReuseIdentifier:YPBangumiNewSerializeTableViewCellID];
    [contentTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YPBangumiEndAnimationTableViewCell class]) bundle:nil] forCellReuseIdentifier:YPBangumiEndAnimationTableViewCellID];
    [contentTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YPBangumiRecommondTableViewCell class]) bundle:nil] forCellReuseIdentifier:YPBangumiRecommondTableViewCellID];
    
    // headerView
    YPBangumiContentTableHeaderView *tableHeaderView = [[YPBangumiContentTableHeaderView alloc] init];
    _tableHeaderView = tableHeaderView;
    _tableHeaderView.frame = CGRectMake(0, 0, YPScreenW, 120);
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
    [self.headerVM loadDataArrFromNetwork];
    // 从网络加载推荐内容数据
    [self.bottomVM loadDataArrFromNetwork];
    
    // 轮播图数据信号
    RACSignal *bannerSignal = [self.headerVM.requestCommand execute:nil];
    // 推荐内容数据信号
    RACSignal *recommendContentSignal = [self.bottomVM.requestCommand execute:nil];
    
    @weakify(self);
    [[RACSignal combineLatest:@[bannerSignal,recommendContentSignal]] subscribeNext:^(RACTuple *x) {
        
        @strongify(self);
        
        // 给头部视图VM赋值
        self.tableHeaderView.vm = self.headerVM;
        
        // 刷新tableView数据源
        [self.contentTableView reloadData];
        
        // 结束刷新
        [_contentTableView.mj_header endRefreshing];
        
    } error:^(NSError *error) {
        [YPProgressHUD showError:@"网络错误"];
        [_contentTableView.mj_header endRefreshing];
    }];

}

#pragma mark - UITableViewDelegate & UITableViewDataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return self.bottomVM.modelArr.count;
    }
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        YPBangumiNewSerializeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YPBangumiNewSerializeTableViewCellID];
        cell.model = self.headerVM.model.latestUpdate;
        return cell;
    } else if (indexPath.section == 1) {
        YPBangumiEndAnimationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YPBangumiEndAnimationTableViewCellID];
        cell.modelArr = self.headerVM.model.ends;
        return cell;
    } else if (indexPath.section == 2) {
        YPBangumiRecommondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YPBangumiRecommondTableViewCellID];
        cell.model = self.bottomVM.modelArr[indexPath.row];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 451;
    } else if (indexPath.section == 1) {
        return 231;
    } else if (indexPath.section == 2) {
        return [tableView fd_heightForCellWithIdentifier:YPBangumiRecommondTableViewCellID cacheByIndexPath:indexPath configuration:^(YPBangumiRecommondTableViewCell *cell) {
            cell.model = self.bottomVM.modelArr[indexPath.row];
        }];
    }
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [YPBangumiContentTableSectionHeaderView bangumiContentTableSectionHeaderViewWithIcon:[UIImage imageNamed:@"home_region_icon_33_s"] title:@"新番连载" isShowRightDetailLabel:YES updateCount:self.headerVM.model.latestUpdate.updateCount];
    } else if (section == 1) {
        return [YPBangumiContentTableSectionHeaderView bangumiContentTableSectionHeaderViewWithIcon:[UIImage imageNamed:@"home_region_icon_32_s"] title:@"完结动画" isShowRightDetailLabel:YES updateCount:nil];
    } else if (section == 2) {
        return [YPBangumiContentTableSectionHeaderView bangumiContentTableSectionHeaderViewWithIcon:[UIImage imageNamed:@"home_bangumi_tableHead_bangumiRecommend"] title:@"番剧推荐" isShowRightDetailLabel:NO updateCount:nil];
    }
    
    return nil;
}



@end
