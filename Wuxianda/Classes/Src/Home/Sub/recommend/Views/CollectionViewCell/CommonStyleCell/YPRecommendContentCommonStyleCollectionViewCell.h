//
//  YPRecommendContentCommonStyleCollectionViewCell.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/13.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  普通类型的cell

#import <UIKit/UIKit.h>
@class YPRecommendContentBodyModel;

@interface YPRecommendContentCommonStyleCollectionViewCell : UICollectionViewCell

/** Body模型 */
@property (nonatomic, strong) YPRecommendContentBodyModel *model;

@end
