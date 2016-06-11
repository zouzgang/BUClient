//
//  PresentAntimator.h
//  ZZGAnimation
//
//  Created by dito on 16/3/28.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PresentAntimator : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL bounces;
@property (nonatomic, assign) CGFloat behindViewScale;
@property (nonatomic, assign) CGFloat   behindViewAlpha;
@property (nonatomic, assign) CGFloat transitionDuration;

@property (nonatomic, assign) CGFloat verticalOffset;

- (id)initWithModalViewController:(UIViewController *)modalViewController;

@end
