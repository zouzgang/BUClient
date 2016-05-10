//
//  BUCPostDetailCell.h
//  BUCilent
//
//  Created by dito on 16/5/9.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCBaseTableViewCell.h"
@class BUCPostDetailModel;

@protocol BUCPostDetailCellDelegate <NSObject>

@required
- (void)didClickReplyButtonAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface BUCPostDetailCell : BUCBaseTableViewCell

@property (nonatomic, strong) BUCPostDetailModel *postDetailModel;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<BUCPostDetailCellDelegate>delegate;

@end
