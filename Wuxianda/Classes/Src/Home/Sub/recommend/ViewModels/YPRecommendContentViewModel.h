//
//  YPRecommendContentViewModel.h
//  Wuxianda
//
//  Created by 胡云鹏 on 16/6/9.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  推荐内容VM

#import <Foundation/Foundation.h>
#import "YPRecommendContentModel.h"
// cell
#import "YPRecommendContentCommonStyleCell.h"
#import "YPRecommendContentLargeStyleCell.h"
#import "YPRecommendContentSmallStyleCell.h"

/** 普通类型cell（四图）*/
static NSString * const CommonStyleCellID = @"YPRecommendContentCommonStyleCell";
/** 大图类型cell */
static NSString * const LargeStyleCellID = @"YPRecommendContentLargeStyleCell";
/** 电视剧类型SmallCell */
static NSString * const SmallStyleCellID = @"YPRecommendContentSmallStyleCell";

@interface YPRecommendContentViewModel : NSObject

#pragma mark - Model
/** 推荐内容数据模型 */
@property (nonatomic, strong) YPRecommendContentModel *model;

#pragma mark - init
/** 初始化方法 */
- (instancetype)initWithModel:(YPRecommendContentModel *)model;

#pragma mark - 数据请求相关
/** 请求命令 */
@property (nonatomic, strong, readonly) RACCommand *requestCommand;

/** 从网络中加载启动页数据 */
- (void)loadDataArrFromNetwork;

#pragma mark - 业务逻辑相关
@property (nonatomic, assign, readonly) CGFloat footerSectionHeight;

@property (nonatomic, assign, readonly) CGFloat headerSectionHeight;

@property (nonatomic, assign, readonly) CGFloat cellHeight;

@property (nonatomic, weak) UIView *headerSectionView;

@property (nonatomic, weak) UIView *footerSectionView;

- (UITableViewCell *)cellWithTableView:(UITableView *)tableView;


@end
