//
//  BUCForumModel.h
//  BUCilent
//
//  Created by dito on 16/5/29.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCBaseModel.h"

@interface BUCForumModel : BUCBaseModel

@property (nonatomic, strong) NSNumber *tid;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *dateline;
@property (nonatomic, copy) NSString *lastPostTime;
@property (nonatomic, copy) NSString *lastPoster;
@property (nonatomic, copy) NSString *views;
@property (nonatomic, copy) NSString *replies;


@end
