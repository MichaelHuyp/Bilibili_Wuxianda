//
//  YPMoviePlayerViewController.m
//  Wuxianda
//
//  Created by 胡云鹏 on 16/5/15.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPMoviePlayerViewController.h"
#import "YPMediaControl.h"

@interface YPMoviePlayerViewController ()

@property(atomic,strong) NSURL *url;

@property(atomic, strong) id <IJKMediaPlayback> player;

@end

@implementation YPMoviePlayerViewController


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置Log信息打印
    [IJKFFMoviePlayerController setLogReport:YES];
    // 设置Log等级
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
    // 检查当前FFmpeg版本是否匹配
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    
    // IJKFFOptions 是对视频的配置信息
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    
    // 是否要展示配置信息指示器(默认为NO)
    options.showHudView = NO;
    
    // 配置Player
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.url withOptions:options];
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = self.view.bounds;
    self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
    self.player.shouldAutoplay = YES;
    self.view.autoresizesSubviews = YES;
    [self.view addSubview:self.player.view];
    
    // 视频控制界面
    YPMediaControl *mediaControl = [YPMediaControl mediaControlWithGobackBlock:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    mediaControl.frame = self.view.bounds;
    mediaControl.delegatePlayer = self.player;
    [self.view addSubview:mediaControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [YPApplication setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [YPApplication setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    [self installMovieNotificationObservers];
    
    // 准备播放
    [self.player prepareToPlay];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player shutdown];
    [self removeMovieNotificationObservers];
    
    [YPApplication setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [YPApplication setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

#pragma mark - Override
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}


- (instancetype)initWithURL:(NSURL *)url {
    self = [self initWithNibName:@"YPMoviePlayerViewController" bundle:nil];
    if (self) {
        self.url = url;
    }
    return self;
}

#pragma mark - Public
+ (void)presentFromViewController:(UIViewController *)viewController URL:(NSURL *)url animated:(BOOL)animated
{
    [viewController presentViewController:[[YPMoviePlayerViewController alloc] initWithURL:url] animated:animated completion:nil];
}

#pragma mark - Private
- (void)installMovieNotificationObservers
{
    @weakify(self);
    [[YPNotificationCenter rac_addObserverForName:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player] subscribeNext:^(id x) {
        @strongify(self);
        //    MPMovieLoadStateUnknown        = 0,
        //    MPMovieLoadStatePlayable       = 1 << 0,
        //    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
        //    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
        
        IJKMPMovieLoadState loadState = self.player.loadState;
        
        if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
            YPLog(@"loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
        } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
            YPLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
        } else {
            YPLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
        }
    }];
    
    [[YPNotificationCenter rac_addObserverForName:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player] subscribeNext:^(id x) {
        //    MPMovieFinishReasonPlaybackEnded,
        //    MPMovieFinishReasonPlaybackError,
        //    MPMovieFinishReasonUserExited
        
        int reason = [[[x userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
        
        switch (reason)
        {
            case IJKMPMovieFinishReasonPlaybackEnded:
                YPLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
                break;
                
            case IJKMPMovieFinishReasonUserExited:
                YPLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
                break;
                
            case IJKMPMovieFinishReasonPlaybackError:
                YPLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
                break;
                
            default:
                YPLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
                break;
        }
    }];
    
    [[YPNotificationCenter rac_addObserverForName:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player] subscribeNext:^(id x) {
        YPLog(@"mediaIsPreparedToPlayDidChange\n");
    }];
    
    [[YPNotificationCenter rac_addObserverForName:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player] subscribeNext:^(id x) {
        @strongify(self);
        //    MPMoviePlaybackStateStopped,
        //    MPMoviePlaybackStatePlaying,
        //    MPMoviePlaybackStatePaused,
        //    MPMoviePlaybackStateInterrupted,
        //    MPMoviePlaybackStateSeekingForward,
        //    MPMoviePlaybackStateSeekingBackward
        
        switch (self.player.playbackState)
        {
            case IJKMPMoviePlaybackStateStopped: {
                YPLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)self.player.playbackState);
                break;
            }
            case IJKMPMoviePlaybackStatePlaying: {
                YPLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)self.player.playbackState);
                break;
            }
            case IJKMPMoviePlaybackStatePaused: {
                YPLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)self.player.playbackState);
                break;
            }
            case IJKMPMoviePlaybackStateInterrupted: {
                YPLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)self.player.playbackState);
                break;
            }
            case IJKMPMoviePlaybackStateSeekingForward:
            case IJKMPMoviePlaybackStateSeekingBackward: {
                YPLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)self.player.playbackState);
                break;
            }
            default: {
                YPLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)self.player.playbackState);
                break;
            }
        }
    }];
}

- (void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
}

@end
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
