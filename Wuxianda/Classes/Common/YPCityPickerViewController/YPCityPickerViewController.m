//
//  YPCityPickerViewController.m
//  YPCityPickerViewController
//
//  Created by MichaelPPP on 16/7/1.
//  Copyright © 2016年 MichaelHuyp. All rights reserved.
//

#import "YPCityPickerViewController.h"
#import "pinyin.h"
#import "YPCityPickerHeaderView.h"



@interface YPCityPickerViewController () <UITableViewDelegate,UITableViewDataSource>

/** 城市列表 */
@property (nonatomic, weak) UITableView *tableView;

/** 头部视图 */
@property (nonatomic, weak) YPCityPickerHeaderView *headerView;

/** 首字母数组 */
@property (nonatomic, strong) NSMutableArray *firstLetterArray;

/** 首字母对应的字符串数组 */
@property (nonatomic, strong) NSMutableArray *nameArray;

/** 排序结果字典 */
@property (nonatomic, strong) NSDictionary *sortResultDic;

/** 回调 */
@property (nonatomic, copy) YPCityPickerViewControllerCallBack callBack;


@end

@implementation YPCityPickerViewController

static NSString * const CellID = @"CellID";

#pragma mark - Lazy

- (NSMutableArray *)firstLetterArray
{
    if (!_firstLetterArray) {
        _firstLetterArray = [NSMutableArray array];
    }
    return _firstLetterArray;
}



#pragma mark - Public
+ (instancetype)cityPickerViewControllerWithCallBack:(YPCityPickerViewControllerCallBack)callBack
{
    YPCityPickerViewController *vc = [[YPCityPickerViewController alloc] init];
    vc.callBack = callBack;
    return vc;
}

#pragma mark - Private
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 取得排序字典
    _sortResultDic = [_citys sortedArrayUsingFirstLetter];
    
    // 拿到所有排序后字段的key数组
    NSMutableArray *allKeyArray = [[_sortResultDic allKeys] mutableCopy];
    
    
    // 排序
    [allKeyArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    self.firstLetterArray = allKeyArray;
    
    // UI
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)dealloc
{
//    YPLog(@"城市选择控制器被销毁了");
}


#pragma mark - UI
- (void)createUI
{
    // self
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // navi
    self.navigationItem.title = [NSString stringWithFormat:@"当前城市 - %@",_currentCityName];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"citypicker_cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    // tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YPScreenW, YPScreenH - 64) style:UITableViewStylePlain];
    _tableView = tableView;
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.sectionIndexBackgroundColor = [UIColor whiteColor];
    
    // register cell
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellID];
    
    // headerView
    
    @weakify(self);
    YPCityPickerHeaderView *headerView = [YPCityPickerHeaderView cityPickerHeaderViewWithCallBack:^(NSString *selectCityName) {
        
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.callBack) {
                self.callBack(selectCityName);
            }
        }];
    }];
    _headerView = headerView;
    headerView.frame = CGRectZero;
    headerView.hotCityNames = _hotCitys;
    headerView.currentCityName = _currentCityName;
    
    _tableView.tableHeaderView = _headerView;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _headerView.frame = CGRectMake(0, 0, YPScreenW, _headerView.viewH);
    _tableView.tableHeaderView = _headerView;
}



#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.firstLetterArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key = self.firstLetterArray[section];
    return key;
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.firstLetterArray;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *firstLetter = self.firstLetterArray[section];
    
    NSArray *array = [_sortResultDic objectForKey:firstLetter];
    
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSString *firstLetter = self.firstLetterArray[indexPath.section];
    
    NSArray *array = [_sortResultDic objectForKey:firstLetter];
    
    cell.textLabel.text = array[indexPath.row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *firstLetter = self.firstLetterArray[indexPath.section];
    
    NSArray *array = [_sortResultDic objectForKey:firstLetter];
 
    NSString *selectCityName = array[indexPath.row];
    
    @weakify(self);
    [self dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        if (self.callBack) {
            self.callBack(selectCityName);
        }
    }];
}



@end


















































