//
//  YPMVDemoController.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/18.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPMVDemoController.h"
#import "YPPlayerView.h"

@interface YPMVDemoController ()

@property (nonatomic, weak) YPPlayerView *playerView;

@end

@implementation YPMVDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [YPApplication setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    // playerView
    YPPlayerView *playerView = [[YPPlayerView alloc] init];
    _playerView = playerView;
    playerView.videoUrl = self.videoURL;
    [self.view addSubview:playerView];
    
    [playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.right.equalTo(self.view);
        // 注意此处，宽高比16：9优先级比1000低就行，在因为iPhone 4S宽高比不是16：9
        make.height.equalTo(self.playerView.mas_width).multipliedBy(9.0f / 16.0f).with.priority(750);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.playerView prepareToPlay];
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = [UIColor whiteColor];
        [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(0);
        }];
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.view.backgroundColor = [UIColor blackColor];
        [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(0);
        }];
    }
}

@end
