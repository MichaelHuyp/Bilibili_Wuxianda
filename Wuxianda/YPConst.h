#import "YPDataHandle.h"
#import "YPRequestTool.h"
#import "YYKit.h"
#import "MJExtension.h"
#import "YPProgressHUD.h"
#import "Masonry.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "YYFPSLabel.h"
#import "UINavigationBar+Awesome.h"


// RAC
#import "ReactiveCocoa.h"
#import "NSObject+RACKVOWrapper.h"
#import "RACReturnSignal.h"


// MyCategory
#import "UIImage+YPExtension.h"
#import "UIView+YPExtension.h"
#import "UIViewController+YPInit.h"

#if DEBUG

#define YPLog(FORMAT, ...) fprintf(stderr, "[%s:%d行] %s\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#else

#define YPLog(FORMAT, ...) nil

#endif


#define YPNotificationCenter [NSNotificationCenter defaultCenter]
#define YPUserDefaults [NSUserDefaults standardUserDefaults]
#define YPApplication [UIApplication sharedApplication]
#define YPFileManager [NSFileManager defaultManager]
#define YPDevice [UIDevice currentDevice]




/**
 *  颜色
 */
#define YPBlackColor [UIColor blackColor]
#define YPBlueColor [UIColor blueColor]
#define YPRedColor [UIColor redColor]
#define YPWhiteColor [UIColor whiteColor]
#define YPGrayColor [UIColor grayColor]
#define YPDarkGrayColor [UIColor darkGrayColor]
#define YPLightGrayColor [UIColor lightGrayColor]
#define YPGreenColor [UIColor greenColor]
#define YPCyanColor [UIColor cyanColor]
#define YPYellowColor [UIColor yellowColor]
#define YPMagentaColor [UIColor magentaColor]
#define YPOrangeColor [UIColor orangeColor]
#define YPPurpleColor [UIColor purpleColor]
#define YPBrownColor [UIColor brownColor]
#define YPClearColor [UIColor clearColor]


#define iPHone6Plus ([UIScreen mainScreen].bounds.size.height == 736) ? YES : NO

#define iPHone6 ([UIScreen mainScreen].bounds.size.height == 667) ? YES : NO

#define iPHone5 ([UIScreen mainScreen].bounds.size.height == 568) ? YES : NO

#define iPHone4 ([UIScreen mainScreen].bounds.size.height == 480) ? YES : NO

/** RGB颜色 */
#define YPColor_RGB(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1.0]
#define YPColor_RGBA(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a)]
#define YPColor_RGBA_256(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a) / 255.0]
/** 随机色 */
#define YPRandomColor_RGB YPColor_RGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#define YPRandomColor_RGBA YPColor_RGBA_256(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

/** 弧度制转为角度制 */
#define YPAngle2Radian(angle) ((angle) / 180.0 * M_PI)

/** 屏幕 */
#define YPScreen [UIScreen mainScreen]
/** 屏幕宽度 */
#define YPScreenW [UIScreen mainScreen].bounds.size.width
/** 屏幕高度 */
#define YPScreenH [UIScreen mainScreen].bounds.size.height
/** 屏幕bounds */
#define YPScreenBounds [UIScreen mainScreen].bounds
/** 屏幕伸缩度（Retina时值为2,非Retina值为1）*/
#define YPScreenScale [UIScreen mainScreen].scale


/** 系统状态栏高度 */
UIKIT_EXTERN CGFloat const kAppStatusBarHeight;
/** 系统导航栏高度 */
UIKIT_EXTERN CGFloat const kAppNavigationBarHeight;
/** 系统tabbar高度 */
UIKIT_EXTERN CGFloat const kAppTabBarHeight;

/** 系统间距字段 8 */
UIKIT_EXTERN CGFloat const kAppPadding_8;
/** 系统间距字段 12 */
UIKIT_EXTERN CGFloat const kAppPadding_12;
/** 系统间距字段 16 */
UIKIT_EXTERN CGFloat const kAppPadding_16;
/** 系统间距字段 20 */
UIKIT_EXTERN CGFloat const kAppPadding_20;
/** 系统间距字段 24 */
UIKIT_EXTERN CGFloat const kAppPadding_24;
/** 系统间距字段 28 */
UIKIT_EXTERN CGFloat const kAppPadding_28;
/** 系统间距字段 32 */
UIKIT_EXTERN CGFloat const kAppPadding_32;





//********************** Application常用字段Start *************************//
/** App启动次数 */
UIKIT_EXTERN NSString * const kAppLaunchTimes;
/** App的Appstore访问地址 */
UIKIT_EXTERN NSString * const kAppITunesURL;

/** tabBar被选中的通知 */
UIKIT_EXTERN NSString * const YPTabBarDidSelectNotification;
//********************** Application常用字段End ***************************//






