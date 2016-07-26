//
//  YPCityPickerDemoViewController.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/1.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPCityPickerDemoViewController.h"
#import "YPCityPickerViewController.h"
#import "YPCityPickerNavigationController.h"

@interface YPCityPickerDemoViewController ()

@end

@implementation YPCityPickerDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    YPCityPickerViewController *cityPickerVc = [YPCityPickerViewController cityPickerViewControllerWithCallBack:^(NSString *selectCityName) {
        NSLog(@"%@",selectCityName);
    }];
    
    // 城市列表
    cityPickerVc.citys = [NSArray arrayWithObjects:
                          @"成都", @"深圳", @"上海", @"长沙", @"杭州", @"南京", @"徐州", @"北京",@"成都", @"深圳", @"上海", @"长沙", @"杭州", @"南京", @"徐州", @"北京",@"成都", @"深圳", @"上海", @"长沙", @"杭州", @"南京", @"徐州", @"北京",@"&&^*(&",nil];
    
    // 热门城市
    cityPickerVc.hotCitys = [NSArray arrayWithObjects:
                             @"成都", @"深圳", @"上海", @"长沙", @"杭州",@"成都", @"深圳", @"上海", @"长沙", @"杭州", @"南京", @"徐州", @"北京",@"成都", @"深圳", @"上海", @"长沙", @"杭州", nil];
    
    // 当前城市
    cityPickerVc.currentCityName = @"北京";
    
    
    YPCityPickerNavigationController *navi = [[YPCityPickerNavigationController alloc] initWithRootViewController:cityPickerVc];
    
    [self presentViewController:navi animated:YES completion:nil];
}

@end












































