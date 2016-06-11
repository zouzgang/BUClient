//
//  BUCSearchModel.h
//  BUCilent
//
//  Created by dito on 16/6/11.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCBaseModel.h"

@interface BUCSearchModel : BUCBaseModel

@property (nonatomic, strong) NSNumber *tid;
@property (nonatomic, strong) NSNumber *tidSum;
@property (nonatomic, copy) NSString *postTitle;
@property (nonatomic, copy) NSString *author;

@end
