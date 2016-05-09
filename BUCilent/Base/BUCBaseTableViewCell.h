//
//  BUCBaseTableViewCell.h
//  BUCilent
//
//  Created by dito on 16/5/8.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BUCBaseTableViewCell : UITableViewCell

- (void)setupViews;
- (void)setupConstraints;
- (void)refreshConstraints;
+ (NSString *)cellReuseIdentifier;

@end
