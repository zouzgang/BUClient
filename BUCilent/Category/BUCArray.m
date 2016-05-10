//
//  BUCArray.m
//  BUCilent
//
//  Created by dito on 16/5/9.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCArray.h"
#import "MTLJSONAdapter.h"

NSString *const kArrayParamPage = @"page";
NSString *const kArrayParamPageSize = @"page_size";
NSString *const kArrayParamTotalSize = @"total_size";
NSString *const kArrayParamData = @"data";

@implementation BUCArray {
    
}

- (id)init {
    self = [super init];
    _impl = [[NSMutableArray alloc] init];
    return self;
}

- (id)initWithCapacity:(NSUInteger)numItems {
    self = [super initWithCapacity:numItems];
    _impl = [[NSMutableArray alloc] initWithCapacity:numItems];
    return self;
}

- (NSUInteger)count {
    return [_impl count];
}

- (id)objectAtIndex:(NSUInteger)index {
    return [_impl objectAtIndex:index];
}

- (void)addObjectsFromArray:(NSArray *)otherArray {
    [super addObjectsFromArray:otherArray];
    if ([otherArray isKindOfClass:[BUCArray class]]) {
        BUCArray *arr = (BUCArray *)otherArray;
        self.totalSize = arr.totalSize;
        self.page = arr.page;
        self.pageSize = arr.pageSize;
    }
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    return [_impl insertObject:anObject atIndex:index];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    return [_impl removeObjectAtIndex:index];
}

- (void)addObject:(id)anObject {
    return [_impl addObject:anObject];
}

- (void)removeLastObject {
    return [_impl removeLastObject];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    return [_impl replaceObjectAtIndex:index withObject:anObject];
}

- (BOOL)hasMore {
    if (self.totalSize > self.page * self.pageSize) {
        return YES;
    }
    return NO;
}

#pragma mark - Public

- (void)initWithDictionary:(id)data {
    NSAssert(self.delegate, @"LPArrayDelegate Required");
    
    NSInteger page = [data integerForKey:kArrayParamPage];
    NSInteger pageSize = [data integerForKey:kArrayParamPageSize];
    NSInteger totalSize = [data integerForKey:kArrayParamTotalSize];
    NSError *error;
    NSArray *tmpList = [MTLJSONAdapter modelsOfClass:[self.delegate modelOfClass] fromJSONArray:[data objectForKey:kArrayParamData] error:&error];
    
    if (page == 1) {
        [self removeAllObjects];
    }
    
    if (!tmpList || tmpList.count <= 0) {
        return;
    }
    
    self.page = page;
    self.pageSize = pageSize;
    self.totalSize = totalSize;
    [self addObjectsFromArray:tmpList];
}


@end
