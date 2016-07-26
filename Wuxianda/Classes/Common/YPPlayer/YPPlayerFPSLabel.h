//
//  YPPlayerFPSLabel.h
//  Wuxianda
//
//  Created by 胡云鹏 on 16/7/25.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface YPPlayerFPSLabel : UILabel

@property (nonatomic, weak) IJKFFMoviePlayerController *player;

+ (instancetype)shareFPSLabel;

+ (void)show;

+ (void)dismiss;

@end
