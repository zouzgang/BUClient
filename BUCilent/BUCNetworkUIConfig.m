//
//  BUCNetworkUIConfig.m
//  BUCilent
//
//  Created by dito on 16/6/2.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCNetworkUIConfig.h"
#import "BUCLoadingView.h"

@implementation BUCNetworkUIConfig

+ (void)disPlayLoadingView {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = ([UIApplication sharedApplication].delegate).window;
        UIViewController *topViewController = [self getTopVisibleViewController:keyWindow.rootViewController];
        
        BUCLoadingView *loadingView = [[BUCLoadingView alloc] initWithFrame:CGRectMake(0, 0, keyWindow.bounds.size.width, keyWindow.bounds.size.height)];
        [loadingView startAnimation];
        loadingView.tag = -999;
        [topViewController.view addSubview:loadingView];
    });
}

+ (void)disMissLoadingView {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = ([UIApplication sharedApplication].delegate).window;
        UIViewController *topViewController = [self getTopVisibleViewController:keyWindow.rootViewController];
        
        UIView *loadView = [topViewController.view viewWithTag:-999];
        if (loadView) {
            [loadView removeFromSuperview];
        }
    });
    
}

+ (UIViewController *)getTopVisibleViewController:(UIViewController *)rootViewController {
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
