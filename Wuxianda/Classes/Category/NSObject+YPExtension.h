//
//  NSObject+YPExtension.h
//  xinfenbao
//
//  Created by MichaelPPP on 15/12/21.
//  Copyright (c) 2015年 tianyuanwangluo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (YPExtension)
#if (TARGET_OS_IPHONE)
- (NSString*)className;
+ (NSString*)className;
#endif
@end
