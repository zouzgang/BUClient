//
//  BUCHomeModel.m
//  BUCilent
//
//  Created by dito on 16/5/9.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCHomeModel.h"
#import "BUCHomeLastReplyModel.h"

@implementation BUCHomeModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"fidSum"         : @"fid_sum",
             @"tidSum"     : @"tid_sum",
             @"lastRelpyDict"            : @"lastreply"
             };
}

+ (NSValueTransformer *)avatarJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

//+ (NSValueTransformer *)lastRelpyDictJSONTransformer {
//    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[BUCHomeLastReplyModel class]];
//}

@end