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
#import "BUCHtmlScraper.h"

@implementation BUCPostDetailCell (Reply)

- (void)replyWithPostDetail:(BUCPostDetailModel *)postDetail {
    UIWindow *keyWindow = ([UIApplication sharedApplication].delegate).window;
    UIViewController *topViewController = [self getTopVisibleViewController:keyWindow.rootViewController];
    
    
    BUCReplyViewController *reply = [[BUCReplyViewController alloc] init];
    reply.completBlock = ^(NSString *content, UIImage *attachment) {
        
    };
    reply.tid = postDetail.tid;
    
    
    reply.quoteContent = [NSString stringWithFormat:@"[quote=%@][b]%@[/b] %@ \n %@[/quote]", postDetail.tid, [self urldecode:postDetail.author], [self parseDatelineToStandard:postDetail.dateline], [[BUCHtmlScraper sharedInstance] convertQuote:[self urldecode:postDetail.message]]];
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
