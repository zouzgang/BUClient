//
//  BUCDataManager.m
//  BUCilent
//
//  Created by dito on 16/5/9.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCDataManager.h"
#import "BUCNetworkAPI.h"
#import "BUCUserManager.h"


@implementation BUCDataManager {
    BUCNetworkEngine *_networkEngine;
    
    NSString *_session;
}

+ (BUCDataManager *)sharedInstance {
    static BUCDataManager *sharedInstance;
    static dispatch_once_t onceSecurePredicate;
    dispatch_once(&onceSecurePredicate, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _networkEngine = [[BUCNetworkEngine alloc] init];
    }
    return self;
}


#pragma mark - Public Methods 
- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters attachment:(UIImage *)attachment isForm:(BOOL)isForm onError:(BUCStringBlock)errorBlcok onSuccess:(BUCResuletBlock)result {
    [self request:URLString parameters:parameters attachment:attachment isForm:isForm count:0 onError:errorBlcok onSuccess:result];
}


#pragma mark - private
- (void)updateSessionOnError:(BUCStringBlock)errorBlock onSuccess:(BUCVoidBlock)voidBlock {
    NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
    
    [json setObject:@"login" forKey:@"action"];
//    [json setObject:self.password forKey:@"password"];
    
    [self request:[BUCNetworkAPI requestURL:kApiLogin] parameters:json attachment:nil isForm:NO count:0 onError:errorBlock onSuccess:^(NSDictionary *result) {
        _session = [result objectForKey:@"session"];
        voidBlock();
    }];

}

- (void)request:(NSString *)URLString parameters:(NSDictionary *)parameters attachment:(UIImage *)attachment isForm:(BOOL)isForm count:(NSInteger)count onError:(BUCStringBlock)errorBlcok onSuccess:(BUCResuletBlock)result {
    [_networkEngine POST:URLString parameters:parameters attachment:attachment isForm:isForm onError:errorBlcok onSuccess:^(NSDictionary *resultBlock) {
        if ([[resultBlock objectForKey:@"result"] isEqualToString:@"success"]) {
            result(resultBlock);
        } else if ([[resultBlock objectForKey:@"result"] isEqualToString:@"fail"]) {
            NSString *msg = [resultBlock objectForKey:@"msg"];
            NSLog(@"ERROR:%@ COUNT:%ld URL:%@", msg, (long)count, URLString);
            if ([msg isEqualToString:@"IP+logged"] && count <= 1) {
                
                [self updateSessionOnError:errorBlcok onSuccess:^{
                    [self request:URLString parameters:parameters attachment:attachment isForm:isForm count:count + 1 onError:errorBlcok onSuccess:result];
                }];
                
            } else if ([msg isEqualToString:@"thread_nopermission"]) {
                errorBlcok(@"该帖设置了访问权限，无法访问");
            } else if ([URLString isEqualToString:@"logging"]) {
                errorBlcok(@"帐号与密码不符，请检查帐号状态");
            } else if ([msg isEqualToString:@"post_sm_isnull"]) {
                errorBlcok(@"发帖失败，请检查内容是否只含有emoj字符");
            } else if ([msg isEqualToString:@"forum+need+password"]) {
                errorBlcok(@"该论坛需要密码才能进入");
            } else {
                errorBlcok(@"未知错误");
            }
        } else {
            errorBlcok(@"未知错误");
        }

    }];
}




@end










































