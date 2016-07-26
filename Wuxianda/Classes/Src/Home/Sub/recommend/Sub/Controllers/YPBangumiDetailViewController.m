//
//  YPBangumiDetailViewController.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/17.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPBangumiDetailViewController.h"
#import "YPBangumiDetailContentViewModel.h"
#import "YPReplyContentViewModel.h"
#import "YPBangumiDetailHeaderView.h"
#import "KissXML-umbrella.h"
#import "YPMoviePlayerViewController.h"
#import "YPReplyTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "YPSeparatorLineView.h"
#import "YPReplyHeaderSectionView.h"
#import "YPReplyTableFooterView.h"

@interface YPBangumiDetailViewController () <UITableViewDelegate, UITableViewDataSource>

/** 主视图（tableView） */
@property (weak, nonatomic) UITableView *mainView;

/** 导航条 */
@property (nonatomic, weak) UIView *navigationBar;

/** tableView头视图 */
@property (nonatomic, weak) YPBangumiDetailHeaderView *headerView;

/** 番剧详情内容VM */
@property (nonatomic, strong) YPBangumiDetailContentViewModel *bangumiDetailContentVM;

/** 回复内容VM */
@property (nonatomic, strong) YPReplyContentViewModel *replyContentVM;


@end

@implementation YPBangumiDetailViewController

static NSString * const replyCellID = @"YPReplyTableViewCell";


#pragma mark - Lazy

- (YPBangumiDetailContentViewModel *)bangumiDetailContentVM
{
    if (!_bangumiDetailContentVM) {
        _bangumiDetailContentVM = [[YPBangumiDetailContentViewModel alloc] init];
        _bangumiDetailContentVM.season_id = _season_id;
    }
    return _bangumiDetailContentVM;
}

- (YPReplyContentViewModel *)replyContentVM
{
    if (!_replyContentVM) {
        _replyContentVM = [[YPReplyContentViewModel alloc] init];
    }
    return _replyContentVM;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    // 加载番剧详情数据
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [YPApplication setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self.view bringSubviewToFront:_navigationBar];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.navigationController.navigationBar.superview sendSubviewToBack:self.navigationController.navigationBar];
}

- (void)dealloc
{
    [YPRequestTool cancel];
    [YPNotificationCenter removeObserver:self];
}


#pragma mark - UI
- (void)createUI
{
    /**** self ****/
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = YPMainBgColor;
    
    /**** navigationBar ****/
    UIView *navigationBar = [self createBackNormalWithTitle:@"番剧详情"];
    _navigationBar = navigationBar;
    
    /**** tableView ****/
    UITableView *mainView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YPScreenW, YPScreenH) style:UITableViewStylePlain];
    _mainView = mainView;
    _mainView.delegate = self;
    _mainView.dataSource = self;
    _mainView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainView.backgroundColor = YPMainBgColor;
    _mainView.showsVerticalScrollIndicator = NO;
    _mainView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:mainView];
    
    /**** 注册cell ****/
    [_mainView registerNib:[UINib nibWithNibName:NSStringFromClass([YPReplyTableViewCell class]) bundle:nil] forCellReuseIdentifier:replyCellID];
    
    /**** 头部视图 ****/
    @weakify(self);
    YPBangumiDetailHeaderView *headerView = [YPBangumiDetailHeaderView bangumiDetailHeaderViewWithBlock:^(NSUInteger selectEpisodeIndex) {
        @strongify(self);
        
        YPBangumiDetailContentModel *detailContentModel = self.bangumiDetailContentVM.model;
        
        // 拿到剧集模型数组
        NSArray *episodesModels = detailContentModel.episodes;
        
        for (YPBangumiDetailEpisodesModel *episodesModel in episodesModels) {
            
            // 拿到被选中剧集模型 取出其中的剧集id
            if ([episodesModel.index unsignedIntegerValue] == selectEpisodeIndex) {
                
                // 根据剧集模型的index 加载视频数据 (加密了 本地json)
                NSData *data = [NSData dataNamed:@"bangumi_detail_getcidsource.json"];
                id resp = [data jsonValueDecoded];
                NSArray *resultArray = resp[@"result"];
                NSDictionary *resultDict = resultArray[0];
                
                // 拿到cid
                NSString *cid = resultDict[@"cid"];
                
                /**
                 *  http://interface.bilibili.com/playurl?appkey=f3bb208b3d081dc8&cid=3885454&sign=3aa2879fb591b4e297ed3e69156c821e
                 */
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                params[@"appkey"] = @"f3bb208b3d081dc8";
                params[@"cid"] = cid;
                params[@"sign"] = @"3aa2879fb591b4e297ed3e69156c821e";
                
                [manager GET:@"http://interface.bilibili.com/playurl" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    YPLog(@"%@",responseObject);
                    
                    // 加载整个文档
                    DDXMLDocument *document = [[DDXMLDocument alloc] initWithData:responseObject options:0 error:nil];
                    
                    DDXMLElement *durlElement = [document.rootElement elementForName:@"durl"];
                    
                    DDXMLElement *urlEle = [durlElement elementForName:@"url"];
                    
                    NSURL *url = [NSURL URLWithString:[urlEle stringValue]];
                    
                    NSString *scheme = [[url scheme] lowercaseString];
                    if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]) {
                        [YPMoviePlayerViewController presentFromViewController:self URL:url animated:YES];
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    YPLog(@"%@",error);
                }];
                
            }
        }
    }];
    
    _headerView = headerView;
    _mainView.tableHeaderView = headerView;
    
    [RACObserve(_mainView, contentOffset) subscribeNext:^(id x) {
        @strongify(self);
        CGPoint point = [x CGPointValue];
        [self automaticallyAdjustsNaviBar:point];
    }];
    
    [_headerView rac_observeKeyPath:@"viewH" options:NSKeyValueObservingOptionNew observer:self block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        
        @strongify(self);
        
        CGFloat new = [change[@"new"] floatValue];
        
        self.headerView.frame = CGRectMake(0, 0, YPScreenW, new);
        self.mainView.tableHeaderView = self.headerView;
    }];
    
    /**** 尾部视图 ****/
    YPReplyTableFooterView *footerView = [YPReplyTableFooterView viewFromXib];
    footerView.frame = CGRectMake(0, 0, YPScreenW, 44);
    _mainView.tableFooterView = footerView;
}




#pragma mark - Private
/**
 *  自动调节导航栏
 */
- (void)automaticallyAdjustsNaviBar:(CGPoint)point
{
    CGFloat y = point.y;
    
    if (y > 0 && y <= 64) {
        CGFloat delta = 1.0 / 64.0 * y;
        _navigationBar.alpha = delta;
        [YPApplication setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    } else if (y <= 0) {
        _navigationBar.alpha = 0.0f;
        [YPApplication setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    } else {
        _navigationBar.alpha = 1;
        [YPApplication setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }
}

#pragma mark - Data

/**
 *  加载数据
 */
- (void)loadData
{
    // 从网络加载番剧详情数据
    [self.bangumiDetailContentVM loadDataArrFromNetwork];
    
    // 番剧详情内容信号
    @weakify(self);
    [[self.bangumiDetailContentVM.requestCommand execute:nil] subscribeNext:^(id x) {
        @strongify(self);
        
        // 给headerView的数据源赋值
        self.headerView.vm = self.bangumiDetailContentVM;
        
        // 拿到第1话的模型 从而加载第1话的评论数据
        YPBangumiDetailContentModel *detailContentModel = self.bangumiDetailContentVM.model;
        YPBangumiDetailEpisodesModel *episodesModel = detailContentModel.episodes.lastObject;
        self.replyContentVM.oid = episodesModel.av_id;
        
        // 从网络加载回复内容数据
        [self.replyContentVM loadDataArrFromNetwork];
        
        [[self.replyContentVM.requestCommand execute:nil] subscribeNext:^(id x) {
            
            // 刷新数据源
            [self.mainView reloadData];
            
        }];
    }];
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YPReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:replyCellID];
    
    cell.replyModel = self.replyContentVM.model.replies[indexPath.section];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:replyCellID cacheByIndexPath:indexPath configuration:^(YPReplyTableViewCell *cell) {
        // 配置 cell 的数据源，和 "cellForRow" 干的事一致，比如：
        cell.replyModel = self.replyContentVM.model.replies[indexPath.section];
    }];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        YPReplyHeaderSectionView *view = [YPReplyHeaderSectionView viewFromXib];
        [view reloadDataWithPageNum:_replyContentVM.model.page.num replyTotalCount:_replyContentVM.model.page.acount];
        return view;
    } else {
        YPSeparatorLineView *view = [YPSeparatorLineView separatorLineViewWithLineColor:YPLightLineColor leftMargin:44];
        return view;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 44.0f;
    } else {
        return 1.0f;
    }
    return 0.0f;
}


@end




















