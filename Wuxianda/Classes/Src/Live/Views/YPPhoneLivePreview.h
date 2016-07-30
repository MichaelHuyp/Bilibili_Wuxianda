//
//  YPPhoneLivePreview.h
//  Wuxianda
//
//  Created by 胡云鹏 on 16/7/29.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  手机直播preview

#import <UIKit/UIKit.h>

@interface YPPhoneLivePreview : UIView

/** 直播房间地址  rtmp://192.168.0.104:1935/rtmplive/room */
@property (nonatomic, copy) NSString *LiveUrl;

@end
