//
//  YPPlayerView.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/18.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPPlayerView.h"
#import "YPLivePortraitToolView.h"
#import "YPPlayerFPSLabel.h"
#import "YPBufferingProgressView.h"
#import "YPLiveLandscapeToolView.h"
#import "YPLiveModel.h"

@interface YPPlayerView () <YPLiveLandscapeToolViewDelegate>

@property(atomic, strong) id <IJKMediaPlayback> player;

/** 竖屏时的工具View */
@property (nonatomic, weak) YPLivePortraitToolView *portraitToolView;

/** 横屏时的工具View */
@property (nonatomic, weak) YPLiveLandscapeToolView *landscapeToolView;

@property (nonatomic, copy) YPPlayerViewCallBack backCallBack;

@property (nonatomic, copy) YPPlayerViewCallBack fullScreenCallBack;

// 缓冲timer
@property (nonatomic, strong) NSTimer *bufferingTimer;

@property (nonatomic, strong) UIImageView *livePlaceholderImageView;

@end

@implementation YPPlayerView

#pragma mark - Lazy
- (UIImageView *)livePlaceholderImageView
{
    if (!_livePlaceholderImageView) {
        _livePlaceholderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"live_biliv_ico"]];
        [self addSubview:_livePlaceholderImageView];
        [_livePlaceholderImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(16);
        }];
    }
    return _livePlaceholderImageView;
}



#pragma mark - Public

- (void)playerViewBackCallBack:(YPPlayerViewCallBack)callBack
{
    self.backCallBack = callBack;
}

- (void)playerViewFullScreenCallBack:(YPPlayerViewCallBack)callBack
{
    self.fullScreenCallBack = callBack;
}

- (void)play
{
    [self.player play];
}

- (void)pause
{
    [self.player pause];
}

- (void)prepareToPlay
{
    [self.player prepareToPlay];
}

- (void)stop
{
    [self.player stop];
}

- (void)shutdown
{
    [self.player shutdown];
    self.player = nil;
    [YPApplication setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (BOOL)isPlaying
{
    return [self.player isPlaying];
}


#pragma mark - Override
- (instancetype)init
{
    self = [super init];
    if (!self)  return nil;
    [self initialize];
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
}

- (void)initialize
{
    // self
    self.scaleMode = IJKMPMovieScalingModeAspectFill;
    self.liveStyle = YPPlayerViewFullScreenStyleNormal;
    
    // 设置默认的屏幕方向(竖屏)
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
    
    // 添加竖时的工具View
    @weakify(self)
    YPLivePortraitToolView *portraitToolView = [YPLivePortraitToolView livePortraitToolViewWithBackBtnDidTouchCallBack:^{
        @strongify(self);
        if (self.backCallBack) {
            self.backCallBack();
        }
    } fullScreenBtnDidTouchCallBack:^{
        @strongify(self);
        if (self.liveStyle == YPPlayerViewFullScreenStylePhoneLive && self.fullScreenCallBack) {
            self.fullScreenCallBack();
        } else {
            [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
        }
    }];
    _portraitToolView = portraitToolView;
    [self addSubview:portraitToolView];
    

}

- (void)dealloc
{
    [self.bufferingTimer invalidate];
    self.bufferingTimer = nil;
    [YPNotificationCenter removeObserver:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.player.view.frame = self.bounds;
    
    self.portraitToolView.frame = self.bounds;
    
    if (_liveStyle == YPPlayerViewFullScreenStyleNormal) {
        self.landscapeToolView.frame = self.bounds;
    }
    
    
    // 4s，屏幕宽高比不是16：9的问题,player加到控制器上时候
    if (iPHone4) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(YPScreenW *2 / 3);
        }];
    }
    // fix iOS7 crash bug
    [self layoutIfNeeded];
}

#pragma mark 屏幕转屏相关

/**
 *  强制屏幕转屏
 *
 *  @param orientation 屏幕方向
 */
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    // arc下
    if ([YPDevice respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:YPDevice];
        int val = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) {
        // 设置横屏
        [self setOrientationLandscape];
        
    }else if (orientation == UIInterfaceOrientationPortrait) {
        // 设置竖屏
        [self setOrientationPortrait];
        
    }
}

/**
 *  设置横屏的约束
 */
- (void)setOrientationLandscape
{
}

/**
 *  设置竖屏的约束
 */
- (void)setOrientationPortrait
{
}

#pragma mark - Setter
- (void)setVideoUrl:(NSURL *)videoUrl
{
    _videoUrl = videoUrl;
    
    [YPPlayerFPSLabel show];

    // 设置Log信息打印
    [IJKFFMoviePlayerController setLogReport:NO];
    // 设置Log等级
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_SILENT];
    // 检查当前FFmpeg版本是否匹配
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    // IJKFFOptions 是对视频的配置信息
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    
    
    // 配置Player
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.videoUrl withOptions:options];
    self.player.view.frame = self.bounds;
    self.player.scalingMode = self.scaleMode;
    self.player.shouldAutoplay = YES;
    [self.player setPauseInBackground:YES];
    [self addSubview:self.player.view];
    
    // 添加fps帧数观看
    [YPPlayerFPSLabel shareFPSLabel].player = (IJKFFMoviePlayerController *)self.player;
    
    // 设置控制页面的player代理
    _portraitToolView.delegatePlayer = self.player;
    
    
    // 添加水印
    [self livePlaceholderImageView];
    
    // 添加工具view
    [self bringSubviewToFront:_portraitToolView];

    
    // 添加通知
    [self addNotifications];
}

- (void)setScaleMode:(IJKMPMovieScalingMode)scaleMode
{
    if (!self.player) return;
    
    _scaleMode = scaleMode;
    
    self.player.scalingMode = scaleMode;
}

- (void)setLiveModel:(YPLiveModel *)liveModel
{
    if (!self.player || !self.landscapeToolView) return;
    
    _liveModel = liveModel;
    
    if (_liveStyle == YPPlayerViewFullScreenStyleNormal) {
        self.landscapeToolView.liveModel = liveModel;
    }
    
}

- (void)setLiveStyle:(YPPlayerViewFullScreenStyle)liveStyle
{
    _liveStyle = liveStyle;
    
    if (liveStyle == YPPlayerViewFullScreenStyleNormal) {
        // 添加横屏幕时的工具View
        YPLiveLandscapeToolView *landscapeToolView = [YPLiveLandscapeToolView viewFromXib];
        _landscapeToolView = landscapeToolView;
        [self addSubview:landscapeToolView];
        landscapeToolView.hidden = YES;
        landscapeToolView.myDelegate = self;
        _landscapeToolView.delegatePlayer = self.player;
        [self bringSubviewToFront:_landscapeToolView];
        
    } else {
        
    }
}

#pragma mark - Getter
- (UIImage *)thumbnailImageAtCurrentTime
{
    if (!self.player) return nil;
    
    return [self.player thumbnailImageAtCurrentTime];
}


#pragma mark - Notifications
- (void)addNotifications
{
    // 监测设备方向
    [YPDevice beginGeneratingDeviceOrientationNotifications];
    
    @weakify(self);
    [[YPNotificationCenter rac_addObserverForName:UIDeviceOrientationDidChangeNotification object:nil] subscribeNext:^(id x) {
        
        @strongify(self);
        
        // 当前装置的方向
        UIDeviceOrientation orientation = YPDevice.orientation;
        UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
        
        switch (interfaceOrientation) {
            case UIInterfaceOrientationPortraitUpsideDown:
            {
                // 手机倒立
                break;
            }
            case UIInterfaceOrientationPortrait:
            {
                self.portraitToolView.hidden = NO;
                self.landscapeToolView.hidden = YES;
                
                break;
            }
            case UIInterfaceOrientationLandscapeLeft:
            {
                self.portraitToolView.hidden = YES;
                self.landscapeToolView.hidden = NO;
                [YPApplication setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
                break;
            }
            case UIInterfaceOrientationLandscapeRight:
            {
                self.portraitToolView.hidden = YES;
                self.landscapeToolView.hidden = NO;
                [YPApplication setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
                break;
            }
            default:
                break;
        }
    }];
    
    // 注册缓冲的通知
    [[YPNotificationCenter rac_addObserverForName:IJKMPMoviePlayerLoadStateDidChangeNotification object:nil] subscribeNext:^(NSNotification *noti) {
        @strongify(self);
        
        IJKFFMoviePlayerController *player = (IJKFFMoviePlayerController *)noti.object;
        
        if (player.loadState == IJKMPMovieLoadStateStalled) { // 缓冲开始
            YPLog(@"缓冲开始");
            
            [YPBufferingProgressView showInView:self];
            
            // 开启定时器
            self.bufferingTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(buffering) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.bufferingTimer forMode:NSRunLoopCommonModes];
            
        } else if (player.loadState == (IJKMPMovieLoadStatePlayable | IJKMPMovieLoadStatePlaythroughOK)) { // 缓冲结束
            YPLog(@"缓冲结束");
            [self.bufferingTimer invalidate];
            [[YPBufferingProgressView shareInstance] setProgress:0];
            [YPBufferingProgressView dismiss];
            
        }
        
    }];
}

- (void)buffering
{
    YPLog(@"当前缓冲进度为 %zd",[self.player bufferingProgress]);
    [[YPBufferingProgressView shareInstance] setProgress:[self.player bufferingProgress]];
}

#pragma mark - YPLiveLandscapeToolViewDelegate
- (void)liveLandscapeToolViewPortraitBtnDidTouch:(YPLiveLandscapeToolView *)liveLandscapeToolView
{
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
}


@end



























































