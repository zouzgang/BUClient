//
//  BUCSearchModel.m
//  BUCilent
//
//  Created by dito on 16/6/11.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCSearchModel.h"

@implementation BUCSearchModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"postTitle"         : @"subject",
             @"tidSum"     : @"floor",
             };
}

@end
