//
//  BUCPostDetailModelDealer.h
//  BUCilent
//
//  Created by dito on 16/6/13.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BUCPostDetailModel;

@interface BUCPostDetailModelDealer : NSObject

+ (NSArray *)cacheArray:(NSArray<BUCPostDetailModel *> *)rawArray cacheMap:(NSMutableDictionary *)cacheMap;

@end
