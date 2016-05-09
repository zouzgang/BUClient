//
//  BUCUserManager.m
//  BUCilent
//
//  Created by dito on 16/5/9.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCUserManager.h"

static NSString *const kSSUserAccountKey = @"kSSUserAccountKey";

NSString *const kUserLoginNotification = @"kUserLoginNotification";
NSString *const kUserUpdateRefreshNotification = @"kUserUpdateRefreshNotification";
NSString *const kUserLogoutNotification = @"kUserLogoutNotification";

static BUCAccountModel *accountModel;
@implementation BUCUserManager

- (instancetype)init {
    self = [super init];
    if (self) {
        if (!accountModel) {
            accountModel = [[BUCAccountModel alloc] init];
            //            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:kLPNotificationUserNotAuthorizedHandler object:nil];
            [self loadFromUserDefaults];
        }
    }
    return self;
}

+ (instancetype)sharedUserManager {
    static dispatch_once_t onceToken;
    static id sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BUCUserManager alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public Methods

- (BOOL)isLogin {
    if (!accountModel) {
        return NO;
    }
    
    if ([accountModel.uid integerValue] == 0 /*|| [NSString isStringEmpty:accountModel.session]*/) {
        return NO;
    }
    
    return YES;
}

- (void)login:(BUCAccountModel *)accountInfo {
    [self saveAccount:accountInfo];
    //    [[LPNetworkService sharedInstance] addValue:account.token forHTTPHeaderField:@"authorization"];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kUserLoginNotification object:kUserLoginNotification];
}


- (void)logout {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kSSUserAccountKey];
    [userDefaults synchronize];
    
    [self loadFromUserDefaults];
    
    //    NSMutableDictionary *headers = [[LPNetworkRequest sharedInstance].configuration.builtinHeaders mutableCopy];
    //    [headers removeObjectForKey:@"authorization"];
    //    [LPNetworkRequest sharedInstance].configuration.builtinHeaders = [headers copy];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kUserLogoutNotification object:kUserLogoutNotification];
}

- (void)updateAccount:(BUCAccountModel *)accountInfo {
    [self saveAccount:accountInfo];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kUserUpdateRefreshNotification object:nil];
}

- (BUCAccountModel *)account {
    return accountModel.copy;
}


#pragma mark - userDefaults

- (void)loadFromUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:kSSUserAccountKey];
    accountModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (void)saveAccount:(BUCAccountModel *)account {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:account];
    [userDefaults setObject:data forKey:kSSUserAccountKey];
    [userDefaults synchronize];
    
    [self loadFromUserDefaults];
}




@end
