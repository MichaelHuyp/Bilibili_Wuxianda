//
//  YPLaunchViewController.m
//  Wuxianda
//
//  Created by 胡云鹏 on 16/5/21.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPLaunchViewController.h"
#import "UIImageView+WebCache.h"
#import "YPTabBarController.h"
#import "YPLaunchRealmModel.h"
#import "YPLaunchViewModel.h"
#import "YPAlertView.h"



@interface YPLaunchViewController ()

/** 背景加载图片 */
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

/** 启动图片宽度的约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *splashImgWidthCons;

/** 启动图片高度的约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *splashImgHeightCons;

/** 启动图片ImageView */
@property (weak, nonatomic) IBOutlet UIImageView *splashImageView;

/** 启动ViewModel */
@property (nonatomic, strong) YPLaunchViewModel *launchVM;

/** 当前的时间戳是否在模型的时间戳范围内的标志 */
@property (nonatomic, assign) BOOL timeStampInModelTimesFlag;

@end

@implementation YPLaunchViewController

#pragma mark - Lazy
- (YPLaunchViewModel *)launchVM
{
    if (!_launchVM) {
        _launchVM = [[YPLaunchViewModel alloc] init];
    }
    return _launchVM;
}


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // UI
    [self createUI];
}

- (void)dealloc
{
    [YPRequestTool cancel];
}



#pragma mark - UI

- (void)createUI
{
    // 设置启动动画图片的锚点
    self.splashImageView.layer.anchorPoint = CGPointMake(0.5, 0.8);
    // 初始化约束
    [self initSplashCons];
    
    // 加载启动图片(先判断程序是否是第一次启动)
    NSString *appLaunchTimes = [YPUserDefaults objectForKey:kAppLaunchTimes];
    
    if ([appLaunchTimes isNotBlank]) { // 如果不是第一次启动
        // 正常形式加载
        [self setupLaunchImage];
    } else {
        // 第一次启动(动画形式加载)
        
        @weakify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            [self launchWithAnimate];
        });
        

        
        /**
         *  动画加载之后如果有网要进行网络请求缓存图片，
         *  如果没有网络那么不必开启计数器，因此计数器要放在网络请求成功之后开启
         */
        
        if ([YYReachability reachability].status != YYReachabilityStatusNone) { // 有网状态
            [self loadLaunchDataWhenAppFirstOpen];
        }
    }
}

#pragma mark - Data

- (void)loadData:(void(^)(NSArray *launchModels))block
{
    // 从网络加载数据
    [self.launchVM loadLaunchDataArrFromNetwork];
    
    NSString *appLaunchTimes = [YPUserDefaults objectForKey:kAppLaunchTimes];
    
    // 计数器++
    if ([appLaunchTimes isNotBlank]) {
        [self counterIncremented];
    }
    
    [[self.launchVM.requestCommand execute:nil] subscribeNext:^(NSArray *launchModels) {
        // 回调block
        block(launchModels);
    }];
    
    
#warning 加载初始化配置信息数据 暂时不用VM 先实现下拉刷新动画之后再回来处理
    NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
    contentDict[@"appkey"] = @"4f8bed7e5270157bfd00000e";
    contentDict[@"channel"] = @"default";
    contentDict[@"ad_request"] = @1;
    contentDict[@"time"] = @"14:37:54";
    contentDict[@"package"] = @"tv.danmaku.bilianime";
    contentDict[@"type"] = @"online_config";
    contentDict[@"sdk_type"] = @"iOS";
    contentDict[@"sdk_version"] = @"3.4.8";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"content"] = [contentDict mj_JSONString];
    params[@"content"] = [contentDict modelToJSONString];
    
    [YPRequestTool POST:kCheck_config_updateURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        YPLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        YPLog(@"%@",error);
    }];
}

- (void)loadLaunchData
{
    @weakify(self);
    
    [self loadData:^(NSArray *launchModels) {
        @strongify(self);
        if (launchModels.count == 0) {
            // 动画形式加载
            [self launchWithAnimate];
        } else {
            
            for (YPLaunchModel *launchModel in launchModels) {
                
                YPLaunchViewModel *vm = [[YPLaunchViewModel alloc] initWithModel:launchModel];
                
                // 比较时间戳 取出对应的应该放置的启动页
                if ([vm conformsNowtimestamp]) {
                    
                    self.timeStampInModelTimesFlag = YES;
                    
                    YPLaunchRealmModel *realmModel = [[YPLaunchRealmModel alloc] initWithModel:launchModel];
                    
                    // 从网络加载启动页
                    [self launchWithNetwork:realmModel];
                    
                    // 有符合时间戳的模型 存储到数据库中
                    [self storageLaunchModelInDB:realmModel];
                }
            }
            if (self.timeStampInModelTimesFlag == NO) { // 如果请求到的数据不在时间范围内就动画形式加载
                [self launchWithAnimate];
            }
        }
    }];

}

- (void)loadLaunchDataWhenAppFirstOpen
{
    @weakify(self);
    
    [self loadData:^(NSArray *launchModels) {
        @strongify(self);
        if (launchModels.count != 0) {
            for (YPLaunchModel *launchModel in launchModels) {
                
                YPLaunchViewModel *vm = [[YPLaunchViewModel alloc] initWithModel:launchModel];
                
                // 比较时间戳 取出对应的应该放置的启动页
                if ([vm conformsNowtimestamp]) {
                    
                    YPLaunchRealmModel *realmModel = [[YPLaunchRealmModel alloc] initWithModel:launchModel];
                    
                    // 先缓存图片url到本地
                    [SDWebImageManager.sharedManager downloadImageWithURL:[NSURL URLWithString:realmModel.image] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        // 什么也不做。。
                    }];

                    
                    // 有符合时间戳的模型 存储到数据库中
                    [self storageLaunchModelInDB:realmModel];
                }
            }
        }
    }];
}


#pragma mark - Private

#pragma mark 加载启动图片
- (void)setupLaunchImage
{
    NSString *appLaunchTimes = [YPUserDefaults objectForKey:kAppLaunchTimes];
    if ([appLaunchTimes integerValue] == 3) { // 弹出好评框
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [YPAlertView showWithTitle:@"给我们评分" message:@"如果您喜欢哔哩哔哩动画，请给我们评分。您的支持会让我们做得更好!" cancelButtonTitle:@"以后再说" otherButtonTitles:@[@"评分"] andAction:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    YPLog(@"跳转到评分页");
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppITunesURL]];
                }
            } andParentView:nil];
        });
    }
    
    if ([YYReachability reachability].status != YYReachabilityStatusNone) { // 有网状态
        // 加载启动数据
        [self loadLaunchData];
    } else { // 没有网络
        
        // 计数器++
        [self counterIncremented];
        
        /**
         *  先从数据库中加载启动页 判断是否符合时间戳 如果符合 加载启动页
         *  如果不符合 动画形式加载
         */
        RLMResults *results = [YPLaunchRealmModel allObjects];
        if (results.count) {
            YPLaunchRealmModel *model = [results firstObject];
            // 获取时间戳
            long long timestamp = (long long)[[NSDate date] timeIntervalSince1970];
            // 比较时间戳 取出对应的应该放置的启动页
            if (timestamp > [model.start_time longLongValue] && timestamp < [model.end_time longLongValue]) {
                [self launchWithNetwork:model];
            } else {
                // 动画形式加载
                @weakify(self);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    @strongify(self);
                    [self launchWithAnimate];
                });
            }
        } else {
            // 动画形式加载
            @weakify(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongify(self);
                [self launchWithAnimate];
            });
        }
    }
}

#pragma mark - 计数器递增
- (void)counterIncremented
{
    // 计数器++
    NSString *timesStr = [YPUserDefaults objectForKey:kAppLaunchTimes];
    NSInteger times = [timesStr integerValue];
    if (times == NSIntegerMax) {
        times = 1;
    } else {
        times++;
    }
    [YPUserDefaults setValue:[NSString stringWithFormat:@"%ld",times] forKey:kAppLaunchTimes];
}

#pragma mark 动画形式加载启动页
- (void)launchWithAnimate
{
    // 播放默认动画
    self.splashImageView.hidden = NO;
    self.splashImgWidthCons.constant = 320;
    self.splashImgHeightCons.constant = 420;
    
    @weakify(self);
    [UIView animateWithDuration:1.5f delay:0.5f usingSpringWithDamping:0.2f initialSpringVelocity:8.0f options:0 animations:^{
        @strongify(self);
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 切换根控制器
            [UIApplication sharedApplication].keyWindow.rootViewController = [YPTabBarController controller];
            [[UIApplication sharedApplication].keyWindow sendSubviewToBack:[UIApplication sharedApplication].keyWindow.rootViewController.view];
        });
    }];
    
}

#pragma mark 网络形式加载
- (void)launchWithNetwork:(YPLaunchRealmModel *)launchModel
{
    self.splashImageView.hidden = YES;
    
    // 加载广告页
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:launchModel.image] placeholderImage:[UIImage imageNamed:@"launchBg"]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([launchModel.duration floatValue] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 根据模型中的持续时间 切换根控制器
        [UIApplication sharedApplication].keyWindow.rootViewController = [YPTabBarController controller];
        [[UIApplication sharedApplication].keyWindow sendSubviewToBack:[UIApplication sharedApplication].keyWindow.rootViewController.view];
    });
}

#pragma mark 初始化约束
- (void)initSplashCons
{
    self.splashImgWidthCons.constant = 0;
    self.splashImgHeightCons.constant = 0;
    [self.view layoutIfNeeded];
}

#pragma mark 存储启动项模型到数据库中
- (void)storageLaunchModelInDB:(YPLaunchRealmModel *)launchModel
{
    RLMRealm *realm = [RLMRealm defaultRealm];

    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm addObject:launchModel];
    [realm commitWriteTransaction];
}





@end






































