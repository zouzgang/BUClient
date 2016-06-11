//
//  BUCBookCell.h
//  BUCilent
//
//  Created by dito on 16/6/11.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCBaseTableViewCell.h"
@class BUCSearchModel;
@class BUCBookModel;

@interface BUCBookCell : BUCBaseTableViewCell

@property (nonatomic, strong) BUCSearchModel *searchModel;
@property (nonatomic, strong) BUCBookModel *bookModel;


@end
