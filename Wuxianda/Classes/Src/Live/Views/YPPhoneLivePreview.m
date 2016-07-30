//
//  YPPhoneLivePreview.m
//  Wuxianda
//
//  Created by 胡云鹏 on 16/7/29.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPPhoneLivePreview.h"
#import "LFLiveSession.h"
#import "UIView+YPLayer.h"

inline static NSString *formatedSpeed(float bytes, float elapsed_milli) {
    
    
    if (elapsed_milli <= 0) {
        return @"N/A";
    }
    
    if (bytes <= 0) {
        return @"0 KB/s";
    }
    
    float bytes_per_sec = ((float)bytes) * 1000.f /  elapsed_milli;
    if (bytes_per_sec >= 1000 * 1000) {
        return [NSString stringWithFormat:@"%.2f MB/s", ((float)bytes_per_sec) / 1000 / 1000];
    } else if (bytes_per_sec >= 1000) {
        return [NSString stringWithFormat:@"%.1f KB/s", ((float)bytes_per_sec) / 1000];
    } else {
        return [NSString stringWithFormat:@"%ld B/s", (long)bytes_per_sec];
    }
}

@interface YPPhoneLivePreview () <LFLiveSessionDelegate>

/** 来疯直播Session */
@property (nonatomic, strong) LFLiveSession *session;

/** 覆盖层View */
@property (weak, nonatomic) IBOutlet UIView *overlayView;

/** 头像imageView */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

/** 标题标签 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/** 直播状态标签 */
@property (weak, nonatomic) IBOutlet UILabel *liveStatusLabel;

/** 开始直播按钮 */
@property (weak, nonatomic) IBOutlet UIButton *startLiveBtn;

/** 相机按钮 */
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;

/** 美颜按钮 */
@property (weak, nonatomic) IBOutlet UIButton *beautyBtn;

/** 我是灯泡 []~(￣▽￣)~* */
@property (weak, nonatomic) IBOutlet UIButton *lightBtn;

/** 灯泡状态,默认为关闭 */
@property (nonatomic) AVCaptureTorchMode torchMode;

/** 我是镜子 []~(￣▽￣)~* */
@property (weak, nonatomic) IBOutlet UIButton *mirrorBtn;

@property (nonatomic, strong) AVCaptureDevice *captureDevice;

@end

@implementation YPPhoneLivePreview

#pragma mark - Lazy

- (LFLiveSession *)session
{
    if (!_session) {
        
        /**
         默认音频质量 audio sample rate: 44MHz(默认44.1Hz iphoneg6以上48Hz), audio bitrate: 64Kbps
         分辨率： 540 *960 帧数：30 码率：800Kps
         方向竖屏
         */
        
        // 视频配置(质量 & 是否是横屏)
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_Medium3 landscape:NO]];
        
        _session.delegate = self;
        _session.showDebugInfo = YES;
        _session.preView = self;
    }
    return _session;
}

#pragma mark - Override
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // self
    self.autoresizingMask = UIViewAutoresizingNone;
    
    // 灯泡默认关闭
    _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _torchMode = AVCaptureTorchModeOff;
    
    // icon
    _iconImageView.layerCornerRadius = _iconImageView.width * 0.5;
    
    // 开始直播按钮
    _startLiveBtn.layerCornerRadius = 24;
    _startLiveBtn.exclusiveTouch = YES;
    
    @weakify(self);
    [[_startLiveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.startLiveBtn.selected = !self.startLiveBtn.selected;
        if (self.startLiveBtn.selected) {
            [self.startLiveBtn setTitle:@"结束直播" forState:UIControlStateNormal];
            LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
            stream.url = self.LiveUrl;
            [self.session startLive:stream];
        } else {
            [self.startLiveBtn setTitle:@"开始直播" forState:UIControlStateNormal];
            [self.session stopLive];
        }
    }];
    
    // 美颜按钮
    _beautyBtn.exclusiveTouch = YES;
    
    [[_beautyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.session.beautyFace = !self.session.beautyFace;
        self.beautyBtn.selected = !self.session.beautyFace;
    }];
    
    // 旋转相机按钮
    _cameraBtn.exclusiveTouch = YES;
    
    [[_cameraBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        AVCaptureDevicePosition devicePositon = self.session.captureDevicePosition;
        self.session.captureDevicePosition = (devicePositon == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
    }];
    
    // 灯泡
    
    _lightBtn.exclusiveTouch = YES;
    [_lightBtn setImage:[[UIImage imageNamed:@"newbarcode_light_off"] imageByTintColor:YPWhiteColor] forState:UIControlStateNormal];
    [_lightBtn setImage:[[UIImage imageNamed:@"newbarcode_light_on"] imageByTintColor:YPWhiteColor] forState:UIControlStateSelected];

    
    [[_lightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        [self.session setTorch:!self.lightBtn.selected];
        
        self.lightBtn.selected = !self.lightBtn.selected;

    }];
    
    // 镜子
    _mirrorBtn.exclusiveTouch = YES;
    [_mirrorBtn setImage:[[UIImage imageNamed:@"mirror"] imageByTintColor:YPWhiteColor] forState:UIControlStateNormal];
    [_mirrorBtn setImage:[[UIImage imageNamed:@"mirror"] imageByTintColor:YPWhiteColor] forState:UIControlStateHighlighted];
    [_mirrorBtn setImage:[[UIImage imageNamed:@"mirror"] imageByTintColor:YPWhiteColor] forState:UIControlStateSelected];
    
    [[_mirrorBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.session setMirror:!self.mirrorBtn.selected];
        self.mirrorBtn.selected = !self.mirrorBtn.selected;
    }];
    
    // 开启摄像头授权
    [self requestAccessForVideo];
    
    // 开启麦克风授权
    [self requestAccessForAudio];
    
}

#pragma mark - 授权
- (void)requestAccessForVideo {
    @weakify(self);
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined: {
            // 许可对话没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        @strongify(self);
                        [self.session setRunning:YES];
                    });
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            // 已经开启授权，可继续
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                [self.session setRunning:YES];
            });
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            
            break;
        default:
            break;
    }
}

- (void)requestAccessForAudio {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            break;
        default:
            break;
    }
}


#pragma mark -- LFStreamingSessionDelegate
/** 直播状态改变的代理 */
- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state {
    NSLog(@"liveStateDidChange: %ld", state);
    switch (state) {
        case LFLiveReady:
            YPLog(@"未连接");
            self.liveStatusLabel.text = @"未连接";
            break;
        case LFLivePending:
            YPLog(@"连接中");
            [YPProgressHUD showWithMessage:@"正在连接..."];
            self.liveStatusLabel.text = @"正在连接...";
            break;
        case LFLiveStart:
            YPLog(@"已连接");
            [YPProgressHUD showSuccess:@"连接成功"];
            self.liveStatusLabel.text = @"正在直播";
            break;
        case LFLiveError:
            YPLog(@"连接错误");
            [YPProgressHUD showError:@"连接错误"];
            self.liveStatusLabel.text = @"未连接";
            break;
        case LFLiveStop:
            self.liveStatusLabel.text = @"未连接";
            YPLog(@"未连接");
            break;
        default:
            break;
    }
}

/** 直播debug信息 */
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug *)debugInfo {
    YPLog(@"debugInfo uploadSpeed: %@", formatedSpeed(debugInfo.currentBandwidth, debugInfo.elapsedMilli));
}

/** socket回调错误信息 */
- (void)liveSession:(nullable LFLiveSession *)session errorCode:(LFLiveSocketErrorCode)errorCode {
    YPLog(@"errorCode: %ld", errorCode);
}

@end
