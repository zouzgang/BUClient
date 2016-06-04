//
//  BUCPostViewController.h
//  BUCilent
//
//  Created by dito on 16/6/1.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCBaseViewController.h"

@interface BUCPostViewController : BUCBaseViewController

@property (nonatomic, strong) NSNumber *tid;
@property (nonatomic, strong) NSNumber *tidSum;
@property (nonatomic, copy) NSString *postTitle;
@property (nonatomic, copy) NSString *author;

- (instancetype)initWithPostTitle:(NSString *)postTitle author:(NSString *)author tid:(NSNumber *)tid tidSum:(NSNumber *)tidSum;

@end
