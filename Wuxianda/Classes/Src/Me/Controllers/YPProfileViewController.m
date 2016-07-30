//
//  YPProfileViewController.m
//  Wuxianda
//
//  Created by 胡云鹏 on 16/7/29.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPProfileViewController.h"
#import "YPPhoneLiveViewController.h"
#import "YPProfileTypeButton.h"

@interface YPProfileViewController ()

/** 容器视图 */
@property (weak, nonatomic) IBOutlet UIView *containerView;

/** 头像按钮 */
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;

/** 设置按钮 */
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;

/** 右箭头 */
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImageView;

/** 个人资料顶部视图 */
@property (weak, nonatomic) IBOutlet UIView *profileTopView;

@property (weak, nonatomic) IBOutlet UIScrollView *profileScrollView;

/** 个人信息头部视图高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileTopViewHeightCons;

/** 我要直播按钮 */
@property (weak, nonatomic) IBOutlet YPProfileTypeButton *phoneLiveBtn;

@end

@implementation YPProfileViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.navigationController.navigationBar setHidden:YES];
    [YPApplication setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

#pragma mark - UI
- (void)createUI
{
    // self
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.autoresizingMask = UIViewAutoresizingNone;
    
    
    // 右箭头
    _rightArrowImageView.image = [[UIImage imageNamed:@"common_rightArrow"] imageByTintColor:YPWhiteColor];
    
    // scrollView
    self.profileScrollView.layer.cornerRadius = 8;
    self.profileScrollView.layer.masksToBounds = YES;
    
    @weakify(self);
    [RACObserve(_profileScrollView, contentOffset) subscribeNext:^(id x) {
        @strongify(self);
        CGPoint point = [x CGPointValue];
        if (point.y > 1) {
            self.profileScrollView.backgroundColor = YPLightLineColor;
        } else {
            self.profileScrollView.backgroundColor = [UIColor colorWithHexString:@"#E75686"];
        }
    }];
    
    
    // containerView
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, YPScreenW, self.containerView.height) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, YPScreenW, self.containerView.height);
    maskLayer.path = maskPath.CGPath;
    self.containerView.layer.mask = maskLayer;
    
    
    // 头像按钮
    [_iconBtn setImage:[[[UIImage imageNamed:@"myicon"] imageByResizeToSize:CGSizeMake(58, 58) contentMode:UIViewContentModeScaleToFill] imageByRoundCornerRadius:29] forState:UIControlStateNormal];
    
    // 我要直播按钮
    [[_phoneLiveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        // 跳转到手机直播控制器
        [self.navigationController pushViewController:[YPPhoneLiveViewController controller] animated:YES];
    }];
}






@end
