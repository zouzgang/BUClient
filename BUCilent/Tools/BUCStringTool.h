//
//  BUCStringTool.h
//  BUCilent
//
//  Created by dito on 16/5/29.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BUCStringTool : NSObject

+ (NSString *)urlencode:(NSString *)string;
+ (NSString *)urldecode:(NSString *)string;

@end
