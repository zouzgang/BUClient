//
//  BUCReplyViewController.h
//  BUCilent
//
//  Created by dito on 16/5/10.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCBaseViewController.h"

typedef void(^BUCReplyCompleteBlock)(NSString *content, UIImage *attachment);

@interface BUCReplyViewController : BUCBaseViewController

@property (nonatomic, copy) BUCReplyCompleteBlock completBlock;
@property (nonatomic, strong) NSNumber *tid;
@property (nonatomic, copy) NSString *quoteContent;


@end
