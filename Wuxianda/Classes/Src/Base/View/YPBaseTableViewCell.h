//
//  YPBaseTableViewCell.h
//  Demo2
//
//  Created by MichaelPPP on 15/11/13.
//  Copyright (c) 2015年 MichaelPPP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPBaseTableViewCell : UITableViewCell

+ (instancetype)cellFromNib:(NSString*)nibName andTableView:(UITableView*)tableView;

@end
