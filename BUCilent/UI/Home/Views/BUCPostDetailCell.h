//
//  BUCPostDetailCell.h
//  BUCilent
//
//  Created by dito on 16/5/9.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCBaseTableViewCell.h"
@class BUCPostDetailModel;

@interface BUCPostDetailCell : BUCBaseTableViewCell

@property (nonatomic, strong) BUCPostDetailModel *postDetailModel;

- (CGFloat)height;
    
@end
