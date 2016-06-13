//
//  BUCNewPostCell.h
//  BUCilent
//
//  Created by dito on 16/6/12.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCBaseTableViewCell.h"
@class BUCNewPostField;

typedef void(^BUCNewPostCellBlock)(NSString *text);

@interface BUCNewPostCell : BUCBaseTableViewCell

@property (nonatomic, strong) BUCNewPostField *field;
@property (nonatomic, copy) BUCNewPostCellBlock inputBlock;

@end
