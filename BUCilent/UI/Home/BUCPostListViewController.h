//
//  BUCPostListViewController.h
//  BUCilent
//
//  Created by dito on 16/6/1.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCBaseViewController.h"

extern const NSInteger kPostListPageSize;

@interface BUCPostListViewController : BUCBaseViewController

@property (nonatomic, strong) NSNumber *tid;
@property (nonatomic, strong) NSNumber *tidSum;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString *postTitle;

@end
