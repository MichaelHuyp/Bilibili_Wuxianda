//
//  YPPhoneLiveViewController.m
//  Wuxianda
//
//  Created by 胡云鹏 on 16/7/29.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPPhoneLiveViewController.h"
#import "YPPhoneLivePreview.h"


@interface YPPhoneLiveViewController () 

@end

@implementation YPPhoneLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = YPMainColor;
    
    YPPhoneLivePreview *preview = [YPPhoneLivePreview viewFromXib];
    // 直播房间地址(输入你本地电脑的RTMP链接)
    preview.LiveUrl = @"rtmp://192.168.0.104:1935/rtmplive/room";
    preview.frame = self.view.bounds;

    [self.view addSubview:preview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}



@end
