//
//  YPLivePortraitToolView.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/18.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPLivePortraitToolView.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "YPBrightnessView.h"

@interface YPLivePortraitToolView ()

/** 粒子动画 */
@property(nonatomic, weak) CAEmitterLayer *emitterLayer;

/** 用来响应事件的View */
@property (weak, nonatomic) IBOutlet UIView *overlayView;

/** 返回按钮 */
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

/** 小型暂停按钮 */
@property (weak, nonatomic) IBOutlet UIButton *littlePauseBtn;

/** 大型暂停按钮 */
@property (weak, nonatomic) IBOutlet UIButton *bigPauseBtn;

/** 全屏按钮 */
@property (weak, nonatomic) IBOutlet UIButton *fullScreenBtn;

/** 音量滑杆 */
@property (nonatomic, strong) UISlider *volumeViewSlider;

#pragma mark - Flag
/** 是否显示覆盖层 */
@property (nonatomic, assign) BOOL isShowOverlay;
/** 是否在调节音量 */
@property (nonatomic, assign) BOOL isVolume;

#pragma mark - CallBack
@property (nonatomic, copy) YPLivePortraitToolViewCallBack backBtnCallBack;
@property (nonatomic, copy) YPLivePortraitToolViewCallBack fullScreenBtnCallBack;



@end

@implementation YPLivePortraitToolView

#pragma mark - Lazy
- (CAEmitterLayer *)emitterLayer
{
    if (!_emitterLayer) {
        CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
        // 发射器在xy平面的中心位置
        emitterLayer.emitterPosition = CGPointMake(YPScreenW - 50,YPScreenH-50);
        // 发射器的尺寸大小
        emitterLayer.emitterSize = CGSizeMake(20, 20);
        // 渲染模式
        emitterLayer.renderMode = kCAEmitterLayerUnordered;
        // 开启三维效果
        //    _emitterLayer.preservesDepth = YES;
        NSMutableArray *array = [NSMutableArray array];
        // 创建粒子
        for (int i = 0; i < 10; i++) {
            // 发射单元
            CAEmitterCell *stepCell = [CAEmitterCell emitterCell];
            // 粒子的创建速率，默认为1/s
            stepCell.birthRate = 5;
            // 粒子存活时间
            stepCell.lifetime = arc4random_uniform(4) + 1;
            // 粒子的生存时间容差
            stepCell.lifetimeRange = 1.5;
            // 颜色
            // fire.color=[[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1]CGColor];
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"good%d_30x30", i]];
            // 粒子显示的内容
            stepCell.contents = (id)[image CGImage];
            // 粒子的名字
            //            [fire setName:@"step%d", i];
            // 粒子的运动速度
            stepCell.velocity = arc4random_uniform(100) + 100;
            // 粒子速度的容差
            stepCell.velocityRange = 80;
            // 粒子在xy平面的发射角度
            stepCell.emissionLongitude = M_PI+M_PI_2;;
            // 粒子发射角度的容差
            stepCell.emissionRange = M_PI_2/6;
            // 缩放比例
            stepCell.scale = 0.5;
            [array addObject:stepCell];
        }
        
        emitterLayer.emitterCells = array;
        
        [self.layer insertSublayer:emitterLayer atIndex:0];
        
        _emitterLayer = emitterLayer;
    }
    return _emitterLayer;
}

#pragma mark - Public
+ (instancetype)livePortraitToolViewWithBackBtnDidTouchCallBack:(YPLivePortraitToolViewCallBack)backBtnCallBack fullScreenBtnDidTouchCallBack:(YPLivePortraitToolViewCallBack)fullScreenBtnCallBack
{
    YPLivePortraitToolView *view = [YPLivePortraitToolView viewFromXib];
    view.backBtnCallBack = backBtnCallBack;
    view.fullScreenBtnCallBack = fullScreenBtnCallBack;
    return view;
}

#pragma mark - Override
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // self
    self.isShowOverlay = YES;
    self.overlayView.alpha = 1;
    
    // button
    @weakify(self);
    [[_backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.backBtnCallBack) {
            self.backBtnCallBack();
        }
    }];
    
    [[_littlePauseBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        // 改变播放状态
        [self changePlayStatus];
    }];
    [[_bigPauseBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        // 改变播放状态
        [self changePlayStatus];
    }];
    
    [[_fullScreenBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.fullScreenBtnCallBack) {
            self.fullScreenBtnCallBack();
        }
    }];
    
    
    // 创建手势
    [self createGesture];
    
    // 自动延迟隐藏覆盖层
    [self autoFadeOutOverlay];
    
    // 获取系统音量
    [self configureVolume];
    
    // 配置亮度View
    [YPBrightnessView sharedBrightnessView];
    
    // 关闭来访动画
    [self.emitterLayer setHidden:YES];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.emitterLayer setHidden:YES];
    
    if (self.height == YPScreenH) {
        // 开启来访动画
        [self.emitterLayer setHidden:NO];
    } else {
        [self.emitterLayer setHidden:YES];
    }
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
    
    self.littlePauseBtn.selected = [self.delegatePlayer isPlaying];
    self.bigPauseBtn.selected = [self.delegatePlayer isPlaying];
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
    self.isVolume ? (self.volumeViewSlider.value -= value / 10000) : (YPScreen.brightness -= value / 10000);
}

@end

















