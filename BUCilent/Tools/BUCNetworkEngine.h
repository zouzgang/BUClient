//
//  BUCNetworkEngine.h
//  BUCilent
//
//  Created by dito on 16/5/8.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^BUCResuletBlock)(NSDictionary *result);
typedef void(^BUCListBlock)(NSArray *list, NSUInteger count);
typedef void(^BUCDataBlock)(NSData *data);
typedef void(^BUCImageBlock)(UIImage *image);
typedef void(^BUCNumberBlock)(NSUInteger number);
typedef void(^BUCErrorBlock)(NSError *error);
typedef void(^BUCStringBlock)(NSString *text);
typedef void(^BUCVoidBlock)(void);

@interface BUCNetworkEngine : NSObject

- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters attachment:(UIImage *)attachment isForm:(BOOL)isForm onError:(BUCStringBlock)errorBlcok onSuccess:(BUCResuletBlock)result;


//- (AFHTTPRequestOperation *)POST:(NSString *)URLString
//                     parameters:(NSDictionary *)parameters
//               startImmediately:(BOOL)startImmediately
//           configurationHandler:(LPNetworkRequestConfigurationHandler)configurationHandler
//              completionHandler:(LPNetworkRequestCompletionHandler)completionHandler {
//    return [self requestOperationWithMethod:LPNetworkRequestMethodGet URLString:URLString parameters:parameters startImmediately:startImmediately constructingBodyWithBlock:nil configurationHandler:configurationHandler completionHandler:completionHandler];
//}

@end
