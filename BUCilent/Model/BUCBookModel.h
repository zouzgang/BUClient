//
//  BUCBookModel.h
//  BUCilent
//
//  Created by dito on 16/5/29.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCBaseModel.h"

@interface BUCBookModel : BUCBaseModel

//@property (nonatomic, copy) NSString *title;
//@property (nonatomic, copy) NSString *tid;
//
//- (instancetype)initModelWithTid:(NSString *)tid title:(NSString *)title;

@property (nonatomic, strong) NSNumber *tid;
@property (nonatomic, strong) NSNumber *tidSum;
@property (nonatomic, copy) NSString *postTitle;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *create;


@end
