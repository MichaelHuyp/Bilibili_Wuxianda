//
//  YPTimer.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/2.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPTimer.h"

@implementation YPTimer

- (instancetype)init
{
    self = [super init];
    if(!self) return nil;
    
    unsigned int numIvars;
    
    Method *method = class_copyMethodList(NSClassFromString(@"NSTimer"), &numIvars);
    
    for (int i = 0; i < numIvars; i++) {
        Method thisIvar = method[i];
        SEL sel = method_getName(thisIvar);
        const char *name = sel_getName(sel);
        YPLog(@"%s",name);
    }
    free(method);
//    unsigned int count = 0;
//    Ivar *ivars = class_copyIvarList([self class], &count);
//    for (int i = 0; i < count; i++) {
//        printf("%s", ivar_getName(ivars[i]));
//    }
    
    return self;
}

@end
