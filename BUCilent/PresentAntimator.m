//
//  PresentAntimator.m
//  ZZGAnimation
//
//  Created by dito on 16/3/28.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "PresentAntimator.h"

@interface PresentAntimator ()

@property (nonatomic, strong) UIViewController *modalViewController;
@property (nonatomic, assign) BOOL isInteractive;
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;
@property CATransform3D tempTransform;


@end

@implementation PresentAntimator
- (id)initWithModalViewController:(UIViewController *)modalViewController {
    self = [super init];
    if (self) {
        _modalViewController = modalViewController;
        _behindViewAlpha = 0.8;
        _behindViewScale = 0.8;
        _transitionDuration = 1;
        _verticalOffset = 0;
    }
    return self;
}

#pragma mark - AnimationTransition
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.transitionDuration;
}

- (void)animationEnded:(BOOL)transitionCompleted {
    self.isInteractive = NO;
    self.transitionContext = nil;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.isInteractive) {
        return;
    }
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    CGRect startRect;
    [containerView addSubview:toViewController.view];
    toViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    //bottom
    startRect = CGRectMake(0,
                           CGRectGetHeight(containerView.frame),
                           CGRectGetWidth(containerView.bounds),
                           CGRectGetHeight(containerView.bounds));
    CGPoint transformedPoint = CGPointApplyAffineTransform(startRect.origin, toViewController.view.transform);
    toViewController.view.frame = CGRectMake(transformedPoint.x, transformedPoint.y, startRect.size.width, startRect.size.height);
    
    if (toViewController.modalPresentationStyle == UIModalPresentationCustom) {
        [fromViewController beginAppearanceTransition:NO animated:YES];
    }
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.1
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        fromViewController.view.transform = CGAffineTransformScale(fromViewController.view.transform, self.behindViewScale, self.behindViewScale);
                         fromViewController.view.alpha = self.behindViewAlpha;
                         toViewController.view.frame = CGRectMake(0, _verticalOffset, CGRectGetWidth(toViewController.view.frame), CGRectGetHeight(toViewController.view.frame));
    } completion:^(BOOL finished) {
        if (toViewController.modalPresentationStyle == UIModalPresentationCustom) {
            [fromViewController endAppearanceTransition];
        }
        fromViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}

#pragma mark -  transition
- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    self.tempTransform = toViewController.view.layer.transform;
    toViewController.view.alpha = self.behindViewAlpha;
    
    if (fromViewController.modalPresentationStyle == UIModalPresentationFullScreen) {
        [[transitionContext containerView] addSubview:toViewController.view];
    }
    
    [[transitionContext containerView] bringSubviewToFront:fromViewController.view];
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
    if (self.bounces && percentComplete < 0) {
        percentComplete = 0;
    }
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CATransform3D transform = CATransform3DMakeScale(1 + (((1 / self.behindViewScale) - 1) * percentComplete),
                                                     1 + (((1 / self.behindViewScale) - 1) * percentComplete), 1);
    
    toViewController.view.layer.transform = CATransform3DConcat(self.tempTransform, transform);
    toViewController.view.alpha = self.behindViewAlpha + ((1 - self.behindViewAlpha) * percentComplete);
    
    
    CGRect updateRect;
    //bottom
    updateRect = CGRectMake(0, CGRectGetHeight(fromViewController.view.frame) * percentComplete,
                            CGRectGetWidth(fromViewController.view.frame),
                            CGRectGetHeight(fromViewController.view.frame));
    
    if (isnan(updateRect.origin.x) || isinf(updateRect.origin.x)) {
        updateRect.origin.x = 0;
    }
    if (isnan(updateRect.origin.y) || isinf(updateRect.origin.y)) {
        updateRect.origin.y = 0;
    }
    
    CGPoint transformPoint = CGPointApplyAffineTransform(updateRect.origin, fromViewController.view.transform);
    updateRect = CGRectMake(transformPoint.x, transformPoint.y, updateRect.size.width, updateRect.size.height);
    
    fromViewController.view.frame = updateRect;
}

- (void)finishInteractiveTransition {
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //bottom
    CGRect endRect;
    endRect = CGRectMake(0, CGRectGetHeight(fromViewController.view.bounds),
                         CGRectGetWidth(fromViewController.view.frame),
                         CGRectGetHeight(fromViewController.view.frame));
    
    CGPoint transformPoint = CGPointApplyAffineTransform(endRect.origin, fromViewController.view.transform);
    endRect = CGRectMake(transformPoint.x, transformPoint.y, endRect.size.width, endRect.size.height);
    
    if (fromViewController.modalPresentationStyle == UIModalPresentationCustom) {
        [toViewController beginAppearanceTransition:YES animated:YES];
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.1
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGFloat scaleBack = (1 / self.behindViewScale);
                         toViewController.view.layer.transform = CATransform3DScale(self.tempTransform, scaleBack, scaleBack, 1);
                         toViewController.view.alpha = 1.0f;
                         fromViewController.view.frame = endRect;
                     } completion:^(BOOL finished) {
                         if (fromViewController.modalPresentationStyle == UIModalPresentationCustom) {
                             [toViewController endAppearanceTransition];
                         }
                         [transitionContext completeTransition:YES];
                     }];
    
}

- (void)cancelInteractiveTransition {
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.1
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         toViewController.view.layer.transform = self.tempTransform;
                         toViewController.view.alpha = self.behindViewAlpha;
                         fromViewController.view.frame = CGRectMake(0, 0,
                                                                    CGRectGetWidth(fromViewController.view.frame),
                                                                    CGRectGetHeight(fromViewController.view.frame));
                         
                         
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:NO];
                         if (fromViewController.modalPresentationStyle == UIModalPresentationCustom) {
                             [toViewController.view removeFromSuperview];
                         }
                         
                     }];
}

#pragma mark - UIViewControllerTransitioningDelegate Methods

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    if (self.isInteractive) {
        return self;
    }
    return nil;
}
































@end
