//
//  BUCNewPostField.h
//  BUCilent
//
//  Created by dito on 16/6/12.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BUCNewPostField : NSObject

@property (nonatomic, copy) NSString *nameTitle;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) BOOL canEdit;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) UITableViewCellSelectionStyle cellSelectionStyle;
@property (nonatomic, assign) UITableViewCellAccessoryType cellAccessoryType;

+ (NSArray *)fieldList;

@end
