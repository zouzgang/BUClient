//
//  BUCAccountModel.h
//  BUCilent
//
//  Created by dito on 16/5/9.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCBaseModel.h"

@interface BUCAccountModel : BUCBaseModel

@property (nonatomic, copy) NSString *result;
@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *session;

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *lastActivityDate;

@end
