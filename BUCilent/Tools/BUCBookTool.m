//
//  BUCBookTool.m
//  BUCilent
//
//  Created by dito on 16/5/29.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCBookTool.h"
#import "BUCBookModel.h"

NSString *const kModelKey = @"/person.data";
@implementation BUCBookTool


#pragma mark - public methods
+ (void)bookPost:(NSString *)postTid title:(NSString *)title {
    if ([self hasItemFileID:postTid]) {
        [self deleteItemFielID:postTid];
    } else {
//        BUCBookModel *bookModel = [[BUCBookModel alloc] initModelWithTid:postTid title:title];
//        [self addItem:bookModel];
    }
}

+ (NSArray <BUCBookModel *>*)bookList {
     return [self getDataAtFilePath:kModelKey].copy;
}


+ (BOOL)hasItemFileID:(NSString *)tid {
    NSArray *models = [self getDataAtFilePath:kModelKey].copy;
    __block BOOL hasItem = NO;
    if (models) {
        [models enumerateObjectsUsingBlock:^(BUCBookModel *model, NSUInteger idx, BOOL *stop) {
//            if ([model.tid isEqualToString:tid]) {
//                hasItem = YES;
//                *stop = YES;
//            }
        }];
    }
    return hasItem;
    
}

#pragma mark - Private Methods

+ (void)setData:(NSMutableArray *)array atFilePath:(NSString *)filePath {
    if (!array) {
        array = [NSMutableArray array];
    }
    [NSKeyedArchiver archiveRootObject:array toFile:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:filePath]];
}

+ (NSMutableArray *)getDataAtFilePath:(NSString *)filePath {
    NSMutableArray *array = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:filePath]];
    if (!array) {
        array = [NSMutableArray array];
    }
    return array;
}


+ (void)deleteItemFielID:(NSString *)tid {
    __block NSMutableArray *models = [self getDataAtFilePath:kModelKey];
    if (models) {
        [models enumerateObjectsUsingBlock:^(BUCBookModel *model, NSUInteger idx, BOOL *stop) {
//            if ([model.tid isEqualToString:tid]) {
//                [models removeObject:model];
//                *stop = YES;
//            }
        }];
    }
    [self setData:models atFilePath:kModelKey];
}

+ (void)addItem:(BUCBookModel *)bookModel {
    NSMutableArray *models = [self getDataAtFilePath:kModelKey];
    [models addObject:bookModel];
    [self setData:models atFilePath:kModelKey];
}


@end
