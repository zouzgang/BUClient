//
//  BUCPostDetailCell.h
//  BUCilent
//
//  Created by dito on 16/5/9.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCBaseTableViewCell.h"
@class BUCPostDetailModel;

extern const CGFloat kDetailCellLeftPadding;
extern const CGFloat kDetailCellTopPadding;

@interface BUCPostDetailCell : BUCBaseTableViewCell

@property (nonatomic, strong) BUCPostDetailModel *postDetailModel;
@property (nonatomic, strong) NSAttributedString *attributedString;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
