//
//  BUCForumModel.m
//  BUCilent
//
//  Created by dito on 16/5/29.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCForumModel.h"

@implementation BUCForumModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"lastPostTime"         : @"lastpost",
             @"lastPoster"         : @"lastposter"
             };
}

@end
