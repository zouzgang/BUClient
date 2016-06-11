//
//  BUCPostDetailCell+Reply.m
//  BUCilent
//
//  Created by dito on 16/6/7.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCPostDetailCell+Reply.h"
#import "BUCPostDetailModel.h"
#import "BUCReplyViewController.h"

@implementation BUCPostDetailCell (Reply)

- (void)replyWithPostDetail:(BUCPostDetailModel *)postDetail {
    UIWindow *keyWindow = ([UIApplication sharedApplication].delegate).window;
    UIViewController *topViewController = [self getTopVisibleViewController:keyWindow.rootViewController];
    
    
    BUCReplyViewController *reply = [[BUCReplyViewController alloc] init];
    reply.completBlock = ^(NSString *content, UIImage *attachment) {
        
    };
    reply.tid = postDetail.tid;
//    title = [NSString stringWithFormat:@"<b>%@</b>\n\n", title];
    reply.quoteContent = [NSString stringWithFormat:@"<table>%@</table>\n", postDetail.message];
//    reply.quoteContent = postDetail.message;
    [topViewController.navigationController pushViewController:reply animated:NO];
}

- (UIViewController *)getTopVisibleViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self getTopVisibleViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self getTopVisibleViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController *presentedViewController = rootViewController.presentedViewController;
        return [self getTopVisibleViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

@end
