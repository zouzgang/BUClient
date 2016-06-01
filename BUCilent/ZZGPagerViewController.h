//
//  ZZGPagerViewController.h
//  ZZGViewPager
//
//  Created by dito on 16/4/18.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZGPagerViewController;
@class ZZGTabBar;

@protocol ZZGPagerViewControllerDelegate <NSObject>


@optional

- (void)pagerViewController:(ZZGPagerViewController *)pagerViewController didSelectTabAtIndex:(NSUInteger)index;


@end


@protocol ZZGPagerViewControllerDataSource <NSObject>

@required

- (NSInteger)numberOfViewControllers:(ZZGPagerViewController *)pagerViewController;

- (UIViewController *)pagerViewController:(ZZGPagerViewController *)pagerViewController viewControllerAtIndex:(NSInteger)index;

- (NSString *)pagerViewController:(ZZGPagerViewController *)pagerViewController titleAtIndex:(NSInteger)index;

@optional
//todo
- (UIView *)pagerViewController:(ZZGPagerViewController *)pagerViewController customViewAtIndex:(NSInteger)index;


@end




@interface ZZGPagerViewController : UIViewController

//pagebar
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat indicatorHeight;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *itemFont;
@property (nonatomic, strong) ZZGTabBar *pageBar;


@property (nonatomic, assign) NSUInteger selectedIndex;

@property (nonatomic, assign) BOOL scrollEnable;

@property (nonatomic, weak) id<ZZGPagerViewControllerDelegate>delegate;
@property (nonatomic, weak) id<ZZGPagerViewControllerDataSource>dataSource;


- (instancetype)initWithTitles:(NSArray *)titles controllers:(NSArray <UIViewController *> *)controllers;

- (void)reloadViews;

@end
























