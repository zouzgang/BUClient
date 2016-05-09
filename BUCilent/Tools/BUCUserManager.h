//
//  BUCUserManager.h
//  BUCilent
//
//  Created by dito on 16/5/9.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BUCAccountModel.h"

extern NSString *const kUserLoginNotification;
extern NSString *const kUserUpdateRefreshNotification;
extern NSString *const kUserLogoutNotification;

@interface BUCUserManager : NSObject


+ (instancetype)sharedUserManager;

- (BOOL)isLogin;
- (void)login:(BUCAccountModel *)accountModel;
- (void)logout;

- (void)updateAccount:(BUCAccountModel *)accountModel;

- (BUCAccountModel *)accountModel;

@end
