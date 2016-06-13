//
//  BUCBookModel.m
//  BUCilent
//
//  Created by dito on 16/5/29.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCBookModel.h"

@implementation BUCBookModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"postTitle"         : @"subject",
             @"tidSum"     : @"floor",
             @"create"     : @"dt_created"
             };
}


@end
