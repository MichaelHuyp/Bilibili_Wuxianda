//
//  YPLiveContentTableViewCell.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/13.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//  直播内容tableViewCell

#import <UIKit/UIKit.h>
@class YPLivePartitionModel,YPLiveModel;

typedef void(^YPLiveContentTableViewCellBlock)(YPLiveModel *selectedLiveModel);

@interface YPLiveContentTableViewCell : UITableViewCell

@property (nonatomic, strong) YPLivePartitionModel *model;

- (void)liveContentTableViewCellDidSelectedBlock:(YPLiveContentTableViewCellBlock)block;

@end
