//
//  NSDate+YPExtension.m
//  xinfenbao
//
//  Created by MichaelPPP on 16/1/8.
//  Copyright © 2016年 tianyuanwangluo. All rights reserved.
//

#import "NSDate+YPExtension.h"

@implementation NSDate (YPExtension)

- (NSString *)create_time
{
    if (self.isThisYear) { // 今年
        if (self.isToday) { // 今天
            NSDateComponents *cmps = [[NSDate date] deltaFrom:self];
            
            if (cmps.hour >= 1) { // 时间差距 >= 1小时
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1小时 > 时间差距 >= 1分钟
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else { // 1分钟 > 时间差距
                return @"刚刚";
            }
        } else if (self.isYesterday) { // 昨天
            return [self stringWithFormat:@"昨天 HH:mm:ss"];
        } else { // 其他
            return [self stringWithFormat:@"MM-dd HH:mm:ss"];
        }
    } else { // 非今年
        return [self stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
}


- (NSDateComponents *)deltaFrom:(NSDate *)from
{
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 比较时间
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    return [calendar components:unit fromDate:from toDate:self options:0];
}

- (BOOL)isThisYear
{
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    
    return nowYear == selfYear;
}

@end
