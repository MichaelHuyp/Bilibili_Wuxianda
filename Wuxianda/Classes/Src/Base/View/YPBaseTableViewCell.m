//
//  YPBaseTableViewCell.m
//  Demo2
//
//  Created by MichaelPPP on 15/11/13.
//  Copyright (c) 2015年 MichaelPPP. All rights reserved.
//

#import "YPBaseTableViewCell.h"

@implementation YPBaseTableViewCell

+ (instancetype)cellFromNib:(NSString*)nibName andTableView:(UITableView*)tableView
{
    NSString* className = NSStringFromClass([self class]);

    NSString* ID = nibName == nil ? className : nibName;

    UINib* nib = [UINib nibWithNibName:ID bundle:nil];

    [tableView registerNib:nib forCellReuseIdentifier:ID];

    return [tableView dequeueReusableCellWithIdentifier:ID];
}

@end
