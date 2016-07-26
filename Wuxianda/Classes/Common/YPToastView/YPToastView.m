//
//  YPToastView.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/17.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPToastView.h"

@interface YPToastView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *labelContainer;

@end

@implementation YPToastView

#pragma mark - Public

+ (instancetype)toastView
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self viewFromXib];
    });
    return instance;
}

+ (void)showWithTitle:(NSString *)title
{
    YPToastView *view = [YPToastView toastView];
    view.titleLabel.text = title;
    view.titleLabel.alpha = 1;
    view.labelContainer.alpha = 1;
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:view];
    
    
    [UIView animateWithDuration:1.0f animations:^{
        view.titleLabel.alpha = 0;
        view.labelContainer.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}



#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{

}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = YPClearColor;
    self.userInteractionEnabled = NO;
    self.titleLabel.alpha = 1;
    self.labelContainer.alpha = 1;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    self.frame = newSuperview.bounds;
}

@end






























