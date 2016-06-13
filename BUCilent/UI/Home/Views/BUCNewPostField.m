//
//  BUCNewPostField.m
//  BUCilent
//
//  Created by dito on 16/6/12.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCNewPostField.h"

@implementation BUCNewPostField

+ (NSArray *)fieldList {
    NSMutableArray *list = [NSMutableArray array];
    
    BUCNewPostField *forumField = [[BUCNewPostField alloc] init];
    forumField.nameTitle = @"板块";
    forumField.placeholder = @"请选择板块";
    forumField.canEdit = NO;
    forumField.cellSelectionStyle = UITableViewCellSelectionStyleDefault;
    forumField.cellAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [list addObject:forumField];
    
    BUCNewPostField *titleField = [[BUCNewPostField alloc] init];
    titleField.nameTitle = @"标题";
    titleField.placeholder = @"请输入标题";
    titleField.canEdit = YES;
    titleField.cellSelectionStyle = UITableViewCellSelectionStyleNone;
    titleField.cellAccessoryType = UITableViewCellAccessoryNone;
    [list addObject:titleField];
    
//    BUCNewPostField *topicField = [[BUCNewPostField alloc] init];
//    topicField.nameTitle = @"主题";
//    topicField.placeholder = @"请选择主题";
//    topicField.canEdit = NO;
//    topicField.cellSelectionStyle = UITableViewCellSelectionStyleNone;
//    topicField.cellAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    [list addObject:topicField];
    
    BUCNewPostField *attachmentField = [[BUCNewPostField alloc] init];
    attachmentField.nameTitle = @"附件";
    attachmentField.placeholder = @"请选择附件";
    attachmentField.canEdit = NO;
    attachmentField.cellSelectionStyle = UITableViewCellSelectionStyleDefault;
    attachmentField.cellAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [list addObject:attachmentField];
    
    return list.copy;
}

@end
