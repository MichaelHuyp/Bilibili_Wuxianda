//
//  YPSocialShareView.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/16.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YPSocialShareType) {
    YPSocialShareTypeSina = 0,
    YPSocialShareTypeWechatSession,
    YPSocialShareTypeWechatTimeline,
    YPSocialShareTypeQQ,
    YPSocialShareTypeQzone,
    YPSocialShareTypeCopy
};

typedef void(^YPSocialShareViewBlock)(NSInteger selectItemIndex);

@interface YPSocialShareView : UIView

+ (void)showWithBlock:(YPSocialShareViewBlock)block;
+ (void)dismiss;

@end
