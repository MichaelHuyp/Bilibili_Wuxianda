//
//  UIViewController+YPInit.m
//  YPExtension
//
//  Created by 胡云鹏 on 15/8/21.
//  Copyright (c) 2015年 MichaelPPP. All rights reserved.
//

#import "UIViewController+YPInit.h"

@implementation UIViewController (YPInit)

+ (void)load
{
    Method method1 = class_getInstanceMethod(self, NSSelectorFromString(@"dealloc"));
    Method method2 = class_getInstanceMethod(self, @selector(yp_Hook_dealloc));
    method_exchangeImplementations(method1, method2);
}

- (void)yp_Hook_dealloc
{
    
    YPLog(@"%@ %@ 被释放了",self, NSStringFromClass([self class]));
    [self yp_Hook_dealloc];
}



+ (instancetype)controller
{
    UIViewController* controller = [[self alloc] init];
    return controller;
}

- (UIView *)createBackNormalWithTitle:(NSString *)title
{
    UIView *navgationBar = [[UIView alloc] init];
    navgationBar.backgroundColor = YPWhiteColor;
    [self.view addSubview:navgationBar];
    
    [navgationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navgationBar.superview.mas_left);
        make.right.equalTo(navgationBar.superview.mas_right);
        make.top.equalTo(navgationBar.superview.mas_top);
        make.height.mas_equalTo(64);
    }];
    
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setImage:[[UIImage imageNamed:@"fullplayer_icon_back"] imageByTintColor:YPBlackColor] forState:UIControlStateNormal];
    [backBtn setImage:[[UIImage imageNamed:@"fullplayer_icon_back"] imageByTintColor:YPBlackColor] forState:UIControlStateHighlighted];
    @weakify(self);
    [[backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [navgationBar addSubview:backBtn];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backBtn.superview.mas_left).with.offset(16);
        make.top.equalTo(backBtn.superview.mas_top).with.offset(32);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    
    UILabel* titleLable = [[UILabel alloc] init];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = [UIFont systemFontOfSize:17.0];
    titleLable.text = title;
    titleLable.textColor = YPBlackColor;
    [navgationBar addSubview:titleLable];
    
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleLable.superview.mas_centerX);
        make.centerY.equalTo(backBtn.mas_centerY);
    }];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = YPMainLineColor;
    [navgationBar addSubview:bottomLine];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomLine.superview.mas_left);
        make.right.equalTo(bottomLine.superview.mas_right);
        make.bottom.equalTo(bottomLine.superview.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    return navgationBar;
}


- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
