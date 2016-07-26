//
//  YPRecommendViewController.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/5/31.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPRecommendViewController.h"
#import "YPBannerViewModel.h"
#import "YPRecommendContentViewModel.h"
#import "YPBilibiliNormalRefresh.h"
#import "YPProgressHUD.h"
//#import "YZDisplayViewHeader.h"

@interface YPRecommendViewController () <UITableViewDelegate,UITableViewDataSource>

/** 轮播数据源数组 */
@property (nonatomic, strong) NSMutableArray *bannerViewModelArr;

/** 轮播数据VM */
@property (nonatomic, strong) YPBannerViewModel *bannerVM;

/** 推荐内容数据源数组 */
@property (nonatomic, strong) NSMutableArray *recommendContentViewModelArr;

/** 推荐内容VM */
@property (nonatomic, strong) YPRecommendContentViewModel *recommendContentVM;

/** 轮播控件 */
@property (nonatomic, weak) YPBannerView *bannerView;

/** 内容视图(TableView) */
@property (nonatomic, weak) UITableView *contentTableView;

/** 记录上次选中的tabbar索引 */
@property (nonatomic, assign) NSInteger lastSelectedTabBarIndex;

@end

@implementation YPRecommendViewController



#pragma mark - Lazy

- (NSMutableArray *)bannerViewModelArr
{
    if (!_bannerViewModelArr) {
        _bannerViewModelArr = [NSMutableArray array];
    }
    return _bannerViewModelArr;
}

- (YPBannerViewModel *)bannerVM
{
    if (!_bannerVM) {
        _bannerVM = [[YPBannerViewModel alloc] init];
    }
    return _bannerVM;
}

- (NSMutableArray *)recommendContentViewModelArr
{
    if (!_recommendContentViewModelArr) {
        _recommendContentViewModelArr = [NSMutableArray array];
    }
    return _recommendContentViewModelArr;
}

- (YPRecommendContentViewModel *)recommendContentVM
{
    if (!_recommendContentVM) {
        _recommendContentVM = [[YPRecommendContentViewModel alloc] init];
    }
    return _recommendContentVM;
}


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // UI
    [self createUI];
    
    // fps
    [YYFPSLabel show];
}



- (void)dealloc
{
    [YPRequestTool cancel];
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
    
    
    // 订阅轮播图开始滑动以及结束滑动的通知改变首页内容视图是否可以滑动
    @weakify(self);
    [[YPNotificationCenter rac_addObserverForName:kBannerViewWillBeginDraggingNotification object:nil] subscribeNext:^(id x) {
        @strongify(self);
        self.contentTableView.scrollEnabled = NO;
    }];
    
    [[YPNotificationCenter rac_addObserverForName:kBannerViewDidEndDeceleratingNotification object:nil] subscribeNext:^(id x) {
        @strongify(self);
        self.contentTableView.scrollEnabled = YES;
    }];
    
    // 如果是视频方式加载进入的时候刷新
    [[YPNotificationCenter rac_addObserverForName:@"YPVideoLaunchTransitionDidFinishedNotification" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.contentTableView.mj_header beginRefreshing];
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
    
#if 0
    // 订阅YZDisplayViewClickOrScrollDidFinshNote通知决定是否刷新
    [[YPNotificationCenter rac_addObserverForName:YZDisplayViewClickOrScrollDidFinshNote object:nil] subscribeNext:^(NSNotification *x) {
        @strongify(self);
        if ([x.object isKindOfClass:[self class]]) {
            [self.contentTableView.mj_header beginRefreshing];
        }
    }];
#endif
    
    // 注册cell
    
    // 普通四图cell
    UINib *commonNib = [UINib nibWithNibName:NSStringFromClass([YPRecommendContentCommonStyleCell class]) bundle:nil];
    [contentTableView registerNib:commonNib forCellReuseIdentifier:CommonStyleCellID];
    
    // 大图cell
    UINib *largeNib = [UINib nibWithNibName:NSStringFromClass([YPRecommendContentLargeStyleCell class]) bundle:nil];
    [contentTableView registerNib:largeNib forCellReuseIdentifier:LargeStyleCellID];
    
    // 电视剧smallCell
    UINib *smallNib = [UINib nibWithNibName:NSStringFromClass([YPRecommendContentSmallStyleCell class]) bundle:nil];
    [contentTableView registerNib:smallNib forCellReuseIdentifier:SmallStyleCellID];
    
    // 添加轮播控件
    YPBannerView *bannerView = [YPBannerView bannerViewWithFrame:CGRectMake(0, 0, YPScreenW, 120) placeholderImage:nil block:^(NSUInteger didselectIndex) {
        @strongify(self);
        YPBannerViewModel *vm = self.bannerViewModelArr[didselectIndex];
        UIViewController *targetVc = [vm targetController];
        [self.navigationController pushViewController:targetVc animated:YES];
    }];
    _bannerView = bannerView;
    _contentTableView.tableHeaderView = _bannerView;
    
    // 添加下拉刷新控件（暂时用MJ后期进行改进）

    _contentTableView.mj_header = [YPBilibiliNormalRefresh headerWithRefreshingBlock:^{
        @strongify(self);
        
        // 加载页面数据
        [self loadData];
        
    }];
    
    // 进入刷新状态
    if(![YPDataHandle shareHandle].isFromVideoLaunchVc) [self.contentTableView.mj_header beginRefreshing];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _contentTableView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
}

#pragma mark - Data

- (void)loadData
{
    // 从网络加载轮播图数据
    [self.bannerVM loadDataArrFromNetwork];
    // 从网络加载推荐内容数据
    [self.recommendContentVM loadDataArrFromNetwork];
    
    // 轮播图数据信号
    RACSignal *bannerSignal = [self.bannerVM.requestCommand execute:nil];
    // 推荐内容数据信号
    RACSignal *recommendContentSignal = [self.recommendContentVM.requestCommand execute:nil];
    
    @weakify(self);
    [[RACSignal combineLatest:@[bannerSignal,recommendContentSignal]] subscribeNext:^(RACTuple *x) {
        
        @strongify(self);
        
        RACTupleUnpack(NSArray *bannerArr,NSArray *recommendContentArr) = x;
        
        [self.bannerViewModelArr removeAllObjects];
        [self.recommendContentViewModelArr removeAllObjects];
        
        for (YPBannerModel *model in bannerArr) {
            YPBannerViewModel *vm = [[YPBannerViewModel alloc] initWithModel:model];
            [self.bannerViewModelArr addObject:vm];
        }
        
        for (YPRecommendContentModel *model in recommendContentArr) {
            YPRecommendContentViewModel *vm = [[YPRecommendContentViewModel alloc] initWithModel:model];
            [self.recommendContentViewModelArr addObject:vm];
        }
        
        // 为轮播的数据源赋值
        _bannerView.models = [self.bannerViewModelArr copy];
        
        // 刷新数据源
        [_contentTableView reloadData];
        
        // 结束刷新
        [_contentTableView.mj_header endRefreshing];
        
    } error:^(NSError *error) {
        [YPProgressHUD showError:@"网络错误"];
        [_contentTableView.mj_header endRefreshing];
    }];

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.recommendContentViewModelArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YPRecommendContentViewModel *vm = self.recommendContentViewModelArr[indexPath.section];
    return [vm cellWithTableView:tableView];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YPRecommendContentViewModel *vm = self.recommendContentViewModelArr[indexPath.section];
    return vm.cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    YPRecommendContentViewModel *vm = self.recommendContentViewModelArr[section];
    return vm.headerSectionView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    YPRecommendContentViewModel *vm = self.recommendContentViewModelArr[section];
    return vm.footerSectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    YPRecommendContentViewModel *vm = self.recommendContentViewModelArr[section];
    return vm.headerSectionHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    YPRecommendContentViewModel *vm = self.recommendContentViewModelArr[section];
    return vm.footerSectionHeight;
}




@end













































