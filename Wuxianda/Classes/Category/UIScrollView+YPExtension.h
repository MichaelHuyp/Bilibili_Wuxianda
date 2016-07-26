//
//  UIScrollView+YPExtension.h
//  YPExtension
//
//  Created by 胡云鹏 on 15/8/18.
//  Copyright (c) 2015年 MichaelPPP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (YPExtension)
// contentInset
@property (assign, nonatomic) CGFloat insetT;
@property (assign, nonatomic) CGFloat insetB;
@property (assign, nonatomic) CGFloat insetL;
@property (assign, nonatomic) CGFloat insetR;

// contentOffset
@property (assign, nonatomic) CGFloat offsetX;
@property (assign, nonatomic) CGFloat offsetY;

// contentSize
@property (assign, nonatomic) CGFloat contentW;
@property (assign, nonatomic) CGFloat contentH;
@end
