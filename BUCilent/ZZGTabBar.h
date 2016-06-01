//
//  ZZGTabBar.h
//  ZZGViewPager
//
//  Created by dito on 16/4/18.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZGTabBarItem;
@class ZZGPagerViewController;

@protocol ZZGTabBarDelegate <NSObject>

- (void)didSelectedAtSection:(NSInteger)section withDuration:(NSTimeInterval)duration;

@end

@interface ZZGTabBar : UIView

@property (nonatomic, strong) NSArray<ZZGTabBarItem* > *items;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *itemFont;
@property (nonatomic, assign) CGRect topViewRect;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat indicatorHeight;

@property (nonatomic, assign) CGFloat offsetScale;
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, assign) id<ZZGTabBarDelegate> delegate;

@property (nonatomic, assign) ZZGPagerViewController *pageController;

- (void)reloadViews;

@end
