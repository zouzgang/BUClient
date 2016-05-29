//
//  BUCBookModel.m
//  BUCilent
//
//  Created by dito on 16/5/29.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCBookModel.h"

@implementation BUCBookModel

- (instancetype)initModelWithTid:(NSString *)tid title:(NSString *)title {
    self = [super init];
    if (self) {
        _tid = tid;
        _title = title;
    }
    return self;
}

#pragma mark - encode and decoder
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.tid = [aDecoder decodeObjectForKey:@"tid"];
    }
    return  self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.tid forKey:@"tid"];
}


@end
