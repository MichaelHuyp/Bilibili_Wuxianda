//
//  YPBannerCollectionViewCell.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/1.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YPBannerViewModel;

@interface YPBannerCollectionViewCell : UICollectionViewCell

/** 数据模型 */
@property (nonatomic, strong) YPBannerViewModel *vm;

@end
