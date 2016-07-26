//
//  YPVideoLaunchViewController.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/14.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPVideoLaunchViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "YPTabBarController.h"

@interface YPVideoLaunchViewController ()

@property(atomic, strong) id <IJKMediaPlayback> player;


@property (weak, nonatomic) IBOutlet UIButton *enterHome;

@end

@implementation YPVideoLaunchViewController


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;
{
    [YPNotificationCenter postNotificationName:@"YPVideoLaunchTransitionDidFinishedNotification" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [YPDataHandle shareHandle].isFromVideoLaunchVc = YES;
    
    // 进入首页按钮
    _enterHome.layer.cornerRadius = 20;
    _enterHome.layer.borderColor = YPWhiteColor.CGColor;
    _enterHome.layer.borderWidth = 1;
    
    @weakify(self);
    [[_enterHome rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        @strongify(self);
        
        CATransition *anim = [CATransition animation];
        
        anim.type = @"rippleEffect";
        
        anim.duration = 1.5f;
        
        anim.delegate = self;
        
        [[UIApplication sharedApplication].keyWindow.layer addAnimation:anim forKey:nil];
        
        [UIApplication sharedApplication].keyWindow.rootViewController = [YPTabBarController controller];
    }];
    
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
    
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"three" ofType:@"mov"];
    NSURL *url = [NSURL URLWithString:urlStr];
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:options];
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = self.view.bounds;
    self.player.scalingMode = IJKMPMovieScalingModeAspectFill;
    self.player.shouldAutoplay = YES;
    self.view.autoresizesSubviews = YES;
    [self.view addSubview:self.player.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    // 初始化播放器通知
    [self installMovieNotificationObservers];
    
    // 准备播放
    [self.player prepareToPlay];
    
    
    [self.view bringSubviewToFront:_enterHome];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player shutdown];
    [self removeMovieNotificationObservers];
    
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
//                [self.player prepareToPlay];
                [self.player play];
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



#pragma mark - Override

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
