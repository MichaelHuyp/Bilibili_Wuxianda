//
//  YPLiveLandscapeToolView.m
//  Wuxianda
//
//  Created by 胡云鹏 on 16/7/26.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPLiveLandscapeToolView.h"
#import "YPBrightnessView.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "YPLiveModel.h"

@interface YPLiveLandscapeToolView ()

/** 遮罩层 */
@property (weak, nonatomic) IBOutlet UIView *overlayView;

/** 转换为竖屏按钮 */
@property (weak, nonatomic) IBOutlet UIButton *portraitBtn;

/** 直播标题标签 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/** 后台播放按钮 */
@property (weak, nonatomic) IBOutlet UIButton *backgroundPlayBtn;

/** 调节画质按钮 */
@property (weak, nonatomic) IBOutlet UIButton *qualityBtn;

/** 屏幕比例按钮 */
@property (weak, nonatomic) IBOutlet UIButton *scaleBtn;

/** 送礼物按钮 */
@property (weak, nonatomic) IBOutlet UIButton *sendGiftBtn;

/** 分享按钮 */
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

/** 详情标签（xxxx人正在围观） */
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

/** 设置按钮 */
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;

/** 弹幕按钮 */
@property (weak, nonatomic) IBOutlet UIButton *danmakuBtn;

/** 播放按钮 */
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

/** 添加弹幕按钮 */
@property (weak, nonatomic) IBOutlet UIButton *addDanmakuBtn;

/** 静音按钮 */
@property (weak, nonatomic) IBOutlet UIButton *muteBtn;

/** 锁屏按钮 */
@property (weak, nonatomic) IBOutlet UIButton *lockBtn;

/** 音量滑杆 */
@property (nonatomic, strong) UISlider *volumeViewSlider;

#pragma mark - Flag
/** 是否显示覆盖层 */
@property (nonatomic, assign) BOOL isShowOverlay;
/** 是否在调节音量 */
@property (nonatomic, assign) BOOL isVolume;
/** 记录当前音量 */
@property (nonatomic, assign) CGFloat currentVolume;

@end

@implementation YPLiveLandscapeToolView

#pragma mark - Override
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // self
    self.isShowOverlay = YES;
    self.overlayView.alpha = 1;
    

    
    // 播放按钮
    [_playBtn setImage:[[UIImage imageNamed:@"player_pause_bottom_window"] imageByTintColor:YPMainColor] forState:UIControlStateNormal];
    [_playBtn setImage:[[UIImage imageNamed:@"player_play_bottom_window"] imageByTintColor:YPMainColor] forState:UIControlStateSelected];
    
    @weakify(self);
    [[_playBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        // 改变播放状态
        [self changePlayStatus];
    }];
    
    // 恢复竖屏按钮
    [[_portraitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if ([self.myDelegate conformsToProtocol:@protocol(YPLiveLandscapeToolViewDelegate)] && [self.myDelegate respondsToSelector:@selector(liveLandscapeToolViewPortraitBtnDidTouch:)]) {
            [self.myDelegate liveLandscapeToolViewPortraitBtnDidTouch:self];
        }
    }];
    
    // 静音按钮
    [[_muteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        if (self.muteBtn.selected) {
            // 当前为静音 -> 改变为上次保存的音量
            self.volumeViewSlider.value = self.currentVolume;
        } else {
            // 当前为有音量 -> 改变为静音
            self.volumeViewSlider.value = 0;
        }
        self.muteBtn.selected = !self.muteBtn.selected;
    }];
    
    // 创建手势
    [self createGesture];
    
    // 自动延迟隐藏覆盖层
    [self autoFadeOutOverlay];
    
    // 获取系统音量
    [self configureVolume];
    
    // 配置亮度View
    [YPBrightnessView sharedBrightnessView];
}

#pragma mark - Private
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
    [self addGestureRecognizer:pan];
}

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
 *  自动延迟隐藏覆盖层
 */
- (void)autoFadeOutOverlay
{
    if (!self.isShowOverlay) return;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideOverlay) object:nil];
    [self performSelector:@selector(hideOverlay) withObject:nil afterDelay:3.0f];
}

/**
 *  隐藏覆盖层
 */
- (void)hideOverlay
{
    [YPApplication setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    if (self.isShowOverlay == NO) return;
    
    
    @weakify(self);
    [UIView animateWithDuration:0.35f animations:^{
        @strongify(self);
        self.overlayView.alpha = 0;
    } completion:^(BOOL finished) {
        @strongify(self);
        self.isShowOverlay = NO;
    }];
}

/**
 *  显示覆盖层
 */
- (void)showOverlay
{
    [YPApplication setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [YPApplication setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    if (self.isShowOverlay == YES) return;
    
    self.isShowOverlay = YES;
    
    @weakify(self);
    [UIView animateWithDuration:0.35f animations:^{
        @strongify(self);
        self.overlayView.alpha = 1;
    } completion:^(BOOL finished) {
        @strongify(self);
        [self autoFadeOutOverlay];
    }];
}


/**
 *  获取系统音量
 */
- (void)configureVolume
{
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    self.volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            self.volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    
    // 获取当前系统音量
    CGFloat systemVolume = [[AVAudioSession sharedInstance] outputVolume];
    if (systemVolume == 0) {
        self.muteBtn.selected = YES;
    } else {
        self.muteBtn.selected = NO;
    }
    
    // 监听音量改变
    @weakify(self);
    [RACObserve([AVAudioSession sharedInstance], outputVolume) subscribeNext:^(id x) {
        @strongify(self);
        CGFloat tempVolume = [x floatValue];
        if (tempVolume == 0) {
            self.muteBtn.selected = YES;
        } else {
            self.currentVolume = tempVolume;
            self.muteBtn.selected = NO;
        }
    }];
    
    // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
    NSError *setCategoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance]
                    setCategory: AVAudioSessionCategoryPlayback
                    error: &setCategoryError];
    
    if (!success) { /* handle the error in setCategoryError */ }
    
    // 监听耳机插入和拔掉通知
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
            if (x < y){ // 垂直移动
                if (locationPoint.x > self.width / 2) { // 状态改为显示音量调节
                    self.isVolume = YES;
                }else { // 状态改为显示亮度调节
                    self.isVolume = NO;
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            [self verticalMoved:veloctyPoint.y]; // 垂直移动方法只要y方向的值
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            // 垂直移动结束后，把状态改为不再控制音量
            self.isVolume = NO;
            
            break;
        }
        default:
            break;
    }
}

/**
 *  pan垂直移动的方法
 */
- (void)verticalMoved:(CGFloat)value
{
    if (self.isVolume) {
        self.volumeViewSlider.value -= value / 10000;
    } else {
        YPScreen.brightness -= value / 10000;
    }
}

#pragma mark - Setter
- (void)setLiveModel:(YPLiveModel *)liveModel
{
    _liveModel = liveModel;
    
    self.titleLabel.text = liveModel.title;
    self.detailLabel.text = [NSString stringWithFormat:@"%@人正在围观",liveModel.online];
}


@end












































