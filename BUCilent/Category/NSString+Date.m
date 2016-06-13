//
//  NSString+Date.m
//  BUCilent
//
//  Created by dito on 16/6/13.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)

- (NSString *)parseDateString {
    NSDateFormatter *ndf = [[NSDateFormatter alloc] init];
    ndf.dateFormat = @"yyyy-MM-dd HH:mm:ss.0";
    
    ndf.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    ndf.timeZone = [NSTimeZone systemTimeZone];
    NSDate *date = [ndf dateFromString:self];
    
    NSString *output;
    NSTimeInterval timeInterval = abs(date.timeIntervalSinceNow);
    if (timeInterval < 60) {
        output = @"刚刚";
    } else if (timeInterval < 60 * 60) {
        output = [NSString stringWithFormat:@"%d 分钟前", (int)timeInterval / 60];
    } else if (timeInterval < 60 * 60 * 24) {
        output = [NSString stringWithFormat:@"%d 小时前", (int)timeInterval / (60 * 60)];
    } else if (timeInterval < 60 * 60 * 24 * 30) {
        output = [NSString stringWithFormat:@"%d 天前", (int)timeInterval / (60 * 60 * 24)];
    } else if (timeInterval < 60 * 60 * 24 * 30 * 12) {
        output = [NSString stringWithFormat:@"%d 个月前", (int)timeInterval / (60 * 60 * 24 * 30)];
    } else {
        output = [ndf stringFromDate:date];
    }
    
    
    return output;
}

@end
