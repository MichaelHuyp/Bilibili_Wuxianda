//
//  YPBufferingProgressView.h
//  Wuxianda
//
//  Created by 胡云鹏 on 16/7/25.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPBufferingProgressView : UIView

+ (instancetype)shareInstance;

+ (void)showInView:(UIView *)view;

+ (void)dismiss;

@property (nonatomic, assign) NSUInteger progress;

@end
