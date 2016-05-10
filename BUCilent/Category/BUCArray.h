//
//  BUCArray.h
//  BUCilent
//
//  Created by dito on 16/5/9.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BUCArrayDelegate <NSObject>

@required

- (Class)modelOfClass;



@end

@interface BUCArray : NSMutableArray {
    NSMutableArray *_impl;
}

@property (nonatomic, assign) NSInteger totalSize;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) BOOL hasMore;

@property (nonatomic, weak) id<BUCArrayDelegate> delegate;

#pragma mark -

- (void)initWithDictionary:(id)data;

@end



