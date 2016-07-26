
//
//  Const.h
//  BuDeJie
//
//  Created by yz on 15/12/5.
//  Copyright © 2015年 yz. All rights reserved.
//


#import "YZDisplayViewController.h"

// 导航条高度
static CGFloat const YZNavBarH = 64;

// 标题滚动视图的高度
static CGFloat const YZTitleScrollViewH = 44;

// 标题缩放比例
static CGFloat const YZTitleTransformScale = 1.3;

// 下划线默认高度
static CGFloat const YZUnderLineH = 2;

#define YZScreenW [UIScreen mainScreen].bounds.size.width
#define YZScreenH [UIScreen mainScreen].bounds.size.height

// 默认标题字体
#define YZTitleFont [UIFont systemFontOfSize:15]

// 默认标题间距
static CGFloat const margin = 20;

static NSString * const ID = @"cell";

// 标题被点击或者内容滚动完成，会发出这个通知，监听这个通知，可以做自己想要做的事情，比如加载数据
static NSString * const YZDisplayViewClickOrScrollDidFinshNote = @"YZDisplayViewClickOrScrollDidFinshNote";

// 重复点击通知
static NSString * const YZDisplayViewRepeatClickTitleNote = @"YZDisplayViewRepeatClickTitleNote";


