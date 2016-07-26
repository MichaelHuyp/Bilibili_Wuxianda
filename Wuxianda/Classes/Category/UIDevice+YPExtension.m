//
//  UIDevice+YPExtension.m
//  xinfenbao
//
//  Created by MichaelPPP on 15/12/8.
//  Copyright (c) 2015年 tianyuanwangluo. All rights reserved.
//

#import "UIDevice+YPExtension.h"

@implementation UIDevice (YPExtension)

- (BOOL)isSimulator
{
    static BOOL simu;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        simu = NSNotFound != [[self model] rangeOfString:@"Simulator"].location;
    });
    return simu;
}

@end
