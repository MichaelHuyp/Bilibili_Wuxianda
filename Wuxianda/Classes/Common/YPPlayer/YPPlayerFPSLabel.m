//
//  YPPlayerFPSLabel.m
//  Wuxianda
//
//  Created by 胡云鹏 on 16/7/25.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPPlayerFPSLabel.h"

#import "YYKit.h"

#define kSize CGSizeMake(68, 20)

@implementation YPPlayerFPSLabel {
    NSTimer *_timer;
    NSUInteger _count;
    NSTimeInterval _lastTime;
    UIFont *_font;
    UIFont *_subFont;
    
    NSTimeInterval _llll;
}

+ (instancetype)shareFPSLabel
{
    static YPPlayerFPSLabel *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [YPPlayerFPSLabel new];
    });
    return _instance;
}

+ (void)show
{
    UIWindow *fpswindow = [UIApplication sharedApplication].keyWindow;
    fpswindow.backgroundColor = YPClearColor;
    YPPlayerFPSLabel *fps = [YPPlayerFPSLabel shareFPSLabel];
    fps.bottom = fpswindow.bottom - 88;
    fps.right = fpswindow.right - 5;
    [fpswindow addSubview:fps];
}

+ (void)dismiss
{
    [[YPPlayerFPSLabel shareFPSLabel] removeFromSuperview];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size = kSize;
    }
    self = [super initWithFrame:frame];
    
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    self.textAlignment = NSTextAlignmentCenter;
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
    
    _font = [UIFont fontWithName:@"Menlo" size:14];
    if (_font) {
        _subFont = [UIFont fontWithName:@"Menlo" size:4];
    } else {
        _font = [UIFont fontWithName:@"Courier" size:14];
        _subFont = [UIFont fontWithName:@"Courier" size:4];
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:[YYWeakProxy proxyWithTarget:self] selector:@selector(tick:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    return self;
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return kSize;
}

- (void)tick:(NSTimer *)timer {
    CGFloat progress = self.player.fpsAtOutput;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d MVFPS",(int)round(progress)]];
    [text setColor:color range:NSMakeRange(0, text.length - 5)];
    [text setColor:[UIColor whiteColor] range:NSMakeRange(text.length - 5, 5)];
    text.font = _font;
    [text setFont:_subFont range:NSMakeRange(text.length - 6, 1)];
    
    self.attributedText = text;
}

@end