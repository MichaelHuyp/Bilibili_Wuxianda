//
//  YPMoviePlayerViewController.h
//  Wuxianda
//
//  Created by 胡云鹏 on 16/5/15.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  视频播放器

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface YPMoviePlayerViewController : UIViewController


+ (void)presentFromViewController:(UIViewController *)viewController URL:(NSURL *)url animated:(BOOL)animated;

@end
