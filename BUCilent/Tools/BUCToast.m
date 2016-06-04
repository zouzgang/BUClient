//
//  BUCToast.m
//  BUCilent
//
//  Created by dito on 16/6/4.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCToast.h"
#import "BUCToastView.h"

NSInteger const kBUCToastTag= 1001;

@implementation BUCToast

+ (void)showToast:(NSString *)toast {
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
 
    UIView *view = [mainWindow viewWithTag:kBUCToastTag];
    if (view)
        return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            BUCToastView *toastView = [[BUCToastView alloc] initWithFrame:mainWindow.bounds];
            toastView.tag = kBUCToastTag;
            toastView.toast = toast;
            [mainWindow addSubview:toastView];
        }];

        dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
        dispatch_after(delay, dispatch_get_main_queue(), ^{
            UIView *view = [mainWindow viewWithTag:kBUCToastTag];
            if (view) {
                [UIView animateWithDuration:0.25 animations:^{
                    [view removeFromSuperview];
                }];
            }
            
        });
    });


    
    
    
}

@end
