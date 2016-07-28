//
//  YPMediaControl.m
//  Wuxianda
//
//  Created by 胡云鹏 on 16/6/22.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPMediaControl.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "YPBrightnessView.h"
#import "YPAdjustSpeedView.h"
#import "YPBufferingProgressView.h"

@interface YPMediaControl () <UIGestureRecognizerDelegate>

#pragma mark - UI
/** 覆盖层 */
@property (weak, nonatomic) IBOutlet UIView *overlayView;

/** 播放按钮 */
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

/** 滑杆 */
@property (weak, nonatomic) IBOutlet UISlider *slider;

/** 返回按钮 */
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

/** 当前播放时间标签 */
@property (weak, nonatomic) IBOutlet UILabel *currentPlayerTimeLabel;

/** 总播放时间标签 */
@property (weak, nonatomic) IBOutlet UILabel *totalPlayerTimeLabel;

/** 音量滑杆 */
@property (nonatomic, strong) UISlider *volumeViewSlider;

/** 进度条 */
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

/** 调节速度View */
@property (nonatomic, weak) YPAdjustSpeedView *speedView;

#pragma mark - Block
@property (nonatomic, copy) YPMediaControlNormalBlock gobackBlock;

#pragma mark - Flag
/** 是否显示覆盖层 */
@property (nonatomic, assign) BOOL isShowOverlay;

/** 定义一个实例变量，保存滑动方向枚举值 */
@property (nonatomic, assign) PanDirection panDirection;

/** 是否在调节音量 */
@property (nonatomic, assign) BOOL isVolume;

/** 用来保存快进的总时长 */
@property (nonatomic, assign) NSTimeInterval sumTime;
/** 用来保存拖拽的起始时间 */
@property (nonatomic, assign) NSTimeInterval beginTime;

#pragma mark - 定时器
/** 计时器 */
@property (nonatomic, strong) NSTimer *timer;

/** 缓存进度计时器 */
@property (nonatomic, strong) NSTimer *bufferingTimer;

@end

@implementation YPMediaControl


#pragma mark - Public
+ (instancetype)mediaControlWithGobackBlock:(YPMediaControlNormalBlock)goBackBlock
{
    YPMediaControl *control = [YPMediaControl viewFromXib];
    control.gobackBlock = goBackBlock;
    return control;
}

#pragma mark - Override
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    /**** self ***/
    
    // 初始化操作
    [self initialization];
    
    // 创建手势
    [self createGesture];
    
    // 自动延迟隐藏覆盖层
    [self autoFadeOutOverlay];
    
    // 获取系统音量
    [self configureVolume];
    
    // 配置亮度View
    [YPBrightnessView sharedBrightnessView];
    
    // 配置调节速度View
    YPAdjustSpeedView *speedView = [YPAdjustSpeedView viewFromXib];
    _speedView = speedView;
    speedView.layer.cornerRadius = 8;
    speedView.layer.masksToBounds = YES;
    [self addSubview:speedView];
    [speedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 110));
        make.centerX.equalTo(speedView.superview);
        make.centerY.equalTo(speedView.superview);
    }];
    speedView.hidden = YES;
    
    // 计时器
    [self createTimer];
    
    
    /**** UI ****/
    
    // 滑杆
    [_slider setThumbImage:[UIImage imageNamed:@"icmpv_thumb_light"] forState:UIControlStateNormal];
    
    @weakify(self);
    // 播放按钮
    [[_playBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        // 改变播放状态
        [self changePlayStatus];
    }];
    
    // 返回按钮
    [[_backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.gobackBlock) {
            self.gobackBlock();
            [self.delegatePlayer stop];
        }
    }];
    
    // 注册缓冲的通知
    [[YPNotificationCenter rac_addObserverForName:IJKMPMoviePlayerLoadStateDidChangeNotification object:nil] subscribeNext:^(NSNotification *noti) {
        @strongify(self);
        
        // 释放资源
        [self.bufferingTimer invalidate];
        [[YPBufferingProgressView shareInstance] setProgress:0];
        [YPBufferingProgressView dismiss];
        
        IJKFFMoviePlayerController *player = (IJKFFMoviePlayerController *)noti.object;
        
        if (player.loadState == IJKMPMovieLoadStateStalled) { // 缓冲开始
            YPLog(@"缓冲开始");
            
            [YPBufferingProgressView showInView:self];
            
            // 开启定时器
            self.bufferingTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(buffering) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.bufferingTimer forMode:NSRunLoopCommonModes];
            
        } else if (player.loadState == (IJKMPMovieLoadStatePlayable | IJKMPMovieLoadStatePlaythroughOK)) { // 缓冲结束
            YPLog(@"缓冲结束");
            // 释放资源
            [self.bufferingTimer invalidate];
            [[YPBufferingProgressView shareInstance] setProgress:0];
            [YPBufferingProgressView dismiss];
        }
        
    }];

}

- (void)dealloc
{
    [YPNotificationCenter removeObserver:self];
    [self.timer invalidate];
    [self.bufferingTimer invalidate];
    self.timer = nil;
    self.bufferingTimer = nil;
}


#pragma mark - 计时器事件

- (void)buffering
{
    YPLog(@"当前缓冲进度为 %zd",[self.delegatePlayer bufferingProgress]);
    [[YPBufferingProgressView shareInstance] setProgress:[self.delegatePlayer bufferingProgress]];
}

/**
 *  计时器事件
 */
- (void)playerTimerAction
{
//    YPLog(@"currentPlaybackTime - %f",[_delegatePlayer currentPlaybackTime]);
//    YPLog(@"duration - %f",[_delegatePlayer duration]);
//    YPLog(@"playableDuration - %f",[_delegatePlayer playableDuration]);
//    YPLog(@"bufferingProgress - %ld",[_delegatePlayer bufferingProgress]);
    
    
    // 滑杆进度
    _slider.value = [_delegatePlayer currentPlaybackTime] / [_delegatePlayer duration];
    _progressView.progress = [_delegatePlayer playableDuration] / [_delegatePlayer duration];
    
    // 当前时长进度progress
    NSInteger proMin = (NSInteger)[_delegatePlayer currentPlaybackTime] / 60; // 当前分钟
    NSInteger proSec = (NSInteger)[_delegatePlayer currentPlaybackTime] % 60; // 当前秒
    
    // duration 总时长
    NSInteger durMin = (NSInteger)[_delegatePlayer duration] / 60; // 总分钟
    NSInteger durSec = (NSInteger)[_delegatePlayer duration] % 60; // 总秒
    
    _currentPlayerTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    _totalPlayerTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
}

#pragma mark - Private

/**
 *  创建timer
 */
- (void)createTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(playerTimerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

/**
 *  获取系统音量
 */
- (void)configureVolume
{
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    _volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    
    // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
    NSError *setCategoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance]
                    setCategory: AVAudioSessionCategoryPlayback
                    error: &setCategoryError];
    
    if (!success) { /* handle the error in setCategoryError */ }
    
    // 监听耳机插入和拔掉通知
    @weakify(self);
    [[YPNotificationCenter rac_addObserverForName:AVAudioSessionRouteChangeNotification object:nil] subscribeNext:^(NSNotification *notification) {
        
        @strongify(self);
        
        NSDictionary *interuptionDict = notification.userInfo;
        NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
        
        switch (routeChangeReason) {
                
            case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
                // 耳机插入
                break;
                
            case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            {
                // 耳机拔掉
                // 拔掉耳机继续播放
                if (![self.delegatePlayer isPlaying]) {
                    [self.delegatePlayer play];
                }
            }
                break;
                
            case AVAudioSessionRouteChangeReasonCategoryChange:
                // called at start - also when other audio wants to play
                NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
                break;
        }
    }];
}

/**
 *  初始化操作
 */
- (void)initialization
{
    // 初始化显示覆盖层
    _isShowOverlay = YES;
    
    // overlay
    _overlayView.alpha = 1;
}

/**
 *  创建手势
 */
- (void)createGesture
{
    // 单击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    
    // 双击(播放/暂停)
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self addGestureRecognizer:doubleTap];
    
    [tap requireGestureRecognizerToFail:doubleTap];
    
    // 添加平移手势，用来控制音量、亮度、快进快退
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
//    pan.delegate = self;
    [self addGestureRecognizer:pan];
}

/**
 *  自动延迟隐藏覆盖层
 */
- (void)autoFadeOutOverlay
{
    if (!_isShowOverlay) return;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideOverlay) object:nil];
    [self performSelector:@selector(hideOverlay) withObject:nil afterDelay:3.0f];
}

/**
 *  隐藏覆盖层
 */
- (void)hideOverlay
{
    if (_isShowOverlay == NO) return;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    [UIView animateWithDuration:0.35f animations:^{
        _overlayView.alpha = 0;
    } completion:^(BOOL finished) {
        _isShowOverlay = NO;
    }];
}

/**
 *  显示覆盖层
 */
- (void)showOverlay
{
    if (_isShowOverlay == YES) return;
    
    _isShowOverlay = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    [UIView animateWithDuration:0.35f animations:^{
        _overlayView.alpha = 1;
    } completion:^(BOOL finished) {
        [self autoFadeOutOverlay];
    }];
}

/**
 *  改变播放状态（暂停/播放）
 */
- (void)changePlayStatus
{
    if ([self.delegatePlayer isPlaying]) {
        [self.delegatePlayer pause];
    } else {
        [self.delegatePlayer play];
    }
    
    self.playBtn.selected = [self.delegatePlayer isPlaying];
}

/**
 *  pan垂直移动的方法
 */
- (void)verticalMoved:(CGFloat)value
{
    _isVolume ? (_volumeViewSlider.value -= value / 10000) : ([UIScreen mainScreen].brightness -= value / 10000);
}

/**
 *  pan水平移动的方法
 */
- (void)horizontalMoved:(CGFloat)value
{
    // 快进快退的方法
    if (value < 0) {
        _speedView.iconImageView.transform = CGAffineTransformIdentity;
    }
    if (value > 0) {
        _speedView.iconImageView.transform = CGAffineTransformMakeRotation(YPAngle2Radian(180));
    }
    
    // 每次滑动需要叠加时间
    _sumTime += value / 66;
    
    // 需要限定sumTime的范围
    NSTimeInterval totalTime = [_delegatePlayer duration];
    if (_sumTime > totalTime) _sumTime = totalTime;
    if (_sumTime < 0) _sumTime = 0;
    
    // 当前快进的时间
    NSString *nowTime         = [self durationStringWithTime:(NSInteger)_sumTime];
    // 总时间
    NSString *durationTime    = [self durationStringWithTime:(NSInteger)totalTime];
    
    // 刷新speedView的数据源
    NSString *speedViewDetailText = [NSString stringWithFormat:@"%@ / %@",nowTime,durationTime];
    
    NSString *speedViewSpeedText = [NSString stringWithFormat:@"%ld秒 - 中速进退",(NSInteger)(_sumTime - _beginTime)];
    
    _speedView.detailLabel.text = speedViewDetailText;
    _speedView.speedLabel.text = speedViewSpeedText;
    
    // 改变进度
    NSTimeInterval progress = _sumTime / totalTime;
    
    _speedView.progressView.progress = progress;
    _progressView.progress = progress;
    _slider.value = progress;
}

/**
 *  根据时长求出字符串
 *
 *  @param time 时长
 *
 *  @return 时长字符串
 */
- (NSString *)durationStringWithTime:(NSInteger)time
{
    // 获取分钟
    NSString *min = [NSString stringWithFormat:@"%02ld",time / 60];
    // 获取秒数
    NSString *sec = [NSString stringWithFormat:@"%02ld",time % 60];
    
    return [NSString stringWithFormat:@"%@:%@", min, sec];
}

#pragma mark - Action

/**
 *   单击
 */
- (void)tapAction:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.state == UIGestureRecognizerStateRecognized) {
        _isShowOverlay ? ([self hideOverlay]) : ([self showOverlay]);
    }
}

/**
 *  双击播放/暂停
 *
 *  @param gesture UITapGestureRecognizer
 */
- (void)doubleTapAction:(UITapGestureRecognizer *)gesture
{
    // 显示控制层
    [self showOverlay];
    
    // 改变播放状态
    [self changePlayStatus];
}

/**
 *  pan手势事件
 */
- (void)pan:(UIPanGestureRecognizer *)panGesture
{
    //根据在view上Pan的位置，确定是调音量还是亮度
    CGPoint locationPoint = [panGesture locationInView:panGesture.view];
    
    // 我们要响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [panGesture velocityInView:panGesture.view];
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            
            if (x > y) { // 水平移动
                
                // 取消隐藏
                _speedView.hidden = NO;
                
                // 转变状态 之后根据这个状态做事情
                _panDirection = PanDirectionHorizontalMoved;
                
                // 暂停timer
                [_timer setFireDate:[NSDate distantFuture]];
                
                // 给时间Flag赋初值
                _beginTime = [_delegatePlayer currentPlaybackTime];
                _sumTime = [_delegatePlayer currentPlaybackTime];
            }
            else if (x < y){ // 垂直移动
                
                // 转变状态 之后根据这个状态做事情
                _panDirection = PanDirectionVerticalMoved;
                
                if (locationPoint.x > self.width / 2) { // 状态改为显示音量调节
                    _isVolume = YES;
                }else { // 状态改为显示亮度调节
                    _isVolume = NO;
                }
                
            }
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            switch (_panDirection) {
                case PanDirectionHorizontalMoved:{
                    [self horizontalMoved:veloctyPoint.x]; // 水平移动的方法只要x方向的值
                    break;
                }
                case PanDirectionVerticalMoved:{
                    [self verticalMoved:veloctyPoint.y]; // 垂直移动方法只要y方向的值
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (_panDirection) {
                case PanDirectionHorizontalMoved:{
                    
                    // 开启定时器
                    [_timer setFireDate:[NSDate date]];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        // 隐藏视图
                        _speedView.hidden = YES;
                    });
                    
                    // 视频跳转
                    [_delegatePlayer setCurrentPlaybackTime:_sumTime];
                    
                    // 把sumTime滞空，不然会越加越多
                    _sumTime = 0;
                    
                    break;
                }
                case PanDirectionVerticalMoved:{
                    // 垂直移动结束后，把状态改为不再控制音量
                    _isVolume = NO;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        // 隐藏视图
                        _speedView.hidden = YES;
                    });
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    
}

#if 0
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:touch.view];
    // （屏幕上方与下方slider区域） || （在cell上播放视频 && 不是全屏状态） || (播放完了) =====>  不响应pan手势
    if ((point.y > self.height - 44) || point.y < 64)
    {
        return NO;
    }
    return YES;
}

#endif


@end
