//
//  YPLiveDetailViewController.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/18.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPLiveDetailViewController.h"
#import "YPLiveModel.h"
#import "YPPlayerView.h"

@interface YPLiveDetailViewController ()

@property (nonatomic, weak) YPPlayerView *playerView;

@end

@implementation YPLiveDetailViewController

#pragma mark - 屏幕旋转控制方法
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotate
{
    return ([self.model.broadcast_type integerValue] != 1);
}


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.playerView prepareToPlay];
    
    [YPApplication setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [YPApplication setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.playerView shutdown];
    
}

- (void)dealloc
{
    [YPNotificationCenter removeObserver:self];
}


#pragma mark - UI
- (void)createUI
{
    
    // self
    self.view.backgroundColor = YPWhiteColor;
    
    [YPApplication setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    // playerView
    YPPlayerView *playerView = [[YPPlayerView alloc] init];
    _playerView = playerView;
    [self.view addSubview:playerView];
    playerView.videoUrl = [NSURL URLWithString:self.model.playurl];
    if ([self.model.broadcast_type integerValue] == 1) {
        playerView.liveStyle = YPPlayerViewFullScreenStylePhoneLive;
    } else {
        playerView.liveStyle = YPPlayerViewFullScreenStyleNormal;
    }
    playerView.scaleMode = IJKMPMovieScalingModeAspectFit;
    playerView.liveModel = self.model;

    
    @weakify(self);
    [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.view).offset(0);
        make.left.right.equalTo(self.view);
        // 注意此处，宽高比16：9优先级比1000低就行，在因为iPhone 4S宽高比不是16：9
        make.height.equalTo(self.playerView.mas_width).multipliedBy(9.0f / 16.0f).with.priority(750);
    }];
    
    
    [self.playerView playerViewBackCallBack:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.playerView playerViewFullScreenCallBack:^{
        @strongify(self);
        [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(YPScreenH);
        }];
    }];
}

#pragma mark - Override
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = [UIColor whiteColor];
        @weakify(self);
        [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.view).offset(0);
        }];
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.view.backgroundColor = [UIColor blackColor];
        @weakify(self);
        [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.view).offset(0);
        }];
    }
}

#if 0
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 保存当前播放的缩略图
    UIImageWriteToSavedPhotosAlbum(self.playerView.thumbnailImageAtCurrentTime, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [YPProgressHUD showSuccess:@"保存失败!"];
    } else {
        [YPProgressHUD showSuccess:@"保存成功!"];
    }
}
#endif

@end
