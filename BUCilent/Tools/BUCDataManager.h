//
//  BUCDataManager.h
//  BUCilent
//
//  Created by dito on 16/5/9.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BUCNetworkEngine.h"
extern NSString *const kShowLoadingViewWhenNetwork;

@interface BUCDataManager : NSObject

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *session;


+ (BUCDataManager *)sharedInstance;

- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters attachment:(UIImage *)attachment isForm:(BOOL)isForm configure:(NSDictionary *)configInfo onError:(BUCStringBlock)errorBlcok onSuccess:(BUCResuletBlock)result;

@end
