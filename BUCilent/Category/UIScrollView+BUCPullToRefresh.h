//
//  UIScrollView+BUCPullToRefresh.h
//  BUCilent
//
//  Created by dito on 16/5/29.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#pragma mark -  UIScrollView (BUCPullToRefresh)
#import <UIKit/UIKit.h>
@class BUCPullToRefreshView;

@interface UIScrollView (BUCPullToRefresh)

@property (nonatomic, strong, readonly) BUCPullToRefreshView *pullToRefreshView;
@property (nonatomic, assign) BOOL showsPullToRefresh;


- (void)addPullToRefreshActionHandler:(void (^)(void))actionHandler;

@end


#pragma mark - BUCPullToRefreshView
typedef NS_ENUM(NSUInteger, BUCPullToRefreshState) {
    BUCPullToRefreshStateStopped = 0,
    BUCPullToRefreshStateTriggered,
    BUCPullToRefreshStateLoading,
    BUCPullToRefreshStateAll = 10
};

@interface BUCPullToRefreshView : UIView

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong, readonly) UILabel *titleLabel;

@property (nonatomic, readonly) BUCPullToRefreshState state;

- (void)setTitle:(NSString *)title forState:(BUCPullToRefreshState)state;
- (void)setSubtitle:(NSString *)subtitle forState:(BUCPullToRefreshState)state;

- (void)startAnimating;
- (void)stopAnimating;

@end
