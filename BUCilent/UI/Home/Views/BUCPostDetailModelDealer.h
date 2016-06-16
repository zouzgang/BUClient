//
//  BUCPostDetailModelDealer.h
//  BUCilent
//
//  Created by dito on 16/6/13.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BUCPostDetailModel;

extern NSString *const kAttributedStringChangedNotification;


@interface BUCPostDetailModelDealer : NSObject

+ (NSArray *)cacheArray:(NSArray<BUCPostDetailModel *> *)rawArray cacheMap:(NSMutableDictionary *)cacheMap;

@end
