//
//  BUCBookTool.h
//  BUCilent
//
//  Created by dito on 16/5/29.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BUCBookModel;

@interface BUCBookTool : NSObject

+ (void)bookPost:(NSNumber *)postTid title:(NSString *)title;
+ (BOOL)hasItemFileID:(NSNumber *)tid;
+ (NSArray <BUCBookModel *>*)bookList;

@end
