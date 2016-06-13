//
//  NSString+Tools.m
//  BUCilent
//
//  Created by dito on 16/5/9.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "NSString+Tools.h"

@implementation NSString (Tools)

+ (BOOL)isEmptyString:(NSString *)string {
    if (!string)
        return YES;
    if ([string isEqualToString:@""])
        return YES;

    return NO;
}

@end
