//
//  ZZGTabBar.m
//  ZZGViewPager
//
//  Created by dito on 16/4/18.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "ZZGTabBar.h"

static CGFloat _textEdgeInsert = 25;
static CGFloat _badgeEdgeInsert = 4;
static CGFloat _badgeRadius = 8;
static const NSInteger _viewTag = 123;
static const NSInteger _labelTag = 456;
static const NSInteger _badgeViewTag = 789;
static const CGFloat _duration = 0.25;

@interface ZZGTabBar ()

@end

@implementation ZZGTabBar {
    UIScrollView *_scrollView;
    UIView *_selectedView;
    UIView *_indicatorView;
    
    NSMutableArray <UIView *>*_itemViews;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _itemViews = [NSMutableArray array];
        self.backgroundColor = [UIColor whiteColor];
        //        _textColor = [UIColor grayColor];
//        _itemFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
//        self.itemHeight = 36;
//        _itemWidth = 80;
//        self.indicatorHeight = 2;
    }
    return self;
}

- (void)reloadViews {
    if (_scrollView)
        [_scrollView removeFromSuperview];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.backgroundColor = self.backgroundColor;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    [self addSubview:_scrollView];
    
    CGFloat sumWidth = 0;
    for (NSInteger index = 0; index < _titles.count; index ++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(sumWidth, 0, _itemWidth, _itemHeight)];
        view.backgroundColor = self.backgroundColor;
        view.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [view addGestureRecognizer:tap];
        view.tag = _viewTag + index;
        if (index == 0)
            _selectedView = view;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = _titles[index];
        if (index == 0) {
            label.textColor = self.tintColor;
        } else {
            label.textColor = _textColor;
        }
        label.font = _itemFont;
        label.tag = _labelTag;
        label.backgroundColor = [UIColor clearColor];
        
//        UIView *badge = [[UIView alloc] initWithFrame:CGRectMake(12, 12, _badgeRadius, _badgeRadius)];
//        badge.center = CGPointMake(pixel(label.bounds.size.width - _textEdgeInsert + _badgeEdgeInsert + _badgeRadius / 2), pixel(label.center.y + 0.5));
//        badge.layer.masksToBounds = YES;
//        badge.layer.cornerRadius = _badgeRadius / 2;
//        badge.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:64.0/255.0 blue:63.0/255.0 alpha:1];
        [view addSubview:label];
        
        [_scrollView addSubview:view];
        [_itemViews addObject:view];
        sumWidth += view.bounds.size.width;
        
    }
    _scrollView.contentSize = CGSizeMake(sumWidth, 0);
    
    _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, _itemViews[0].bounds.size.height, _itemWidth, _indicatorHeight)];
    _indicatorView.backgroundColor = self.tintColor;
    [_scrollView addSubview:_indicatorView];
}


#pragma mark - LPMath

extern double roundbyunit(double num, double unit) {
    double remain = modf(num, &unit);
    if (remain > unit / 2.0) {
        return ceilbyunit(num, unit);
    } else {
        return floorbyunit(num, unit);
    }
}

extern double ceilbyunit(double num, double unit) {
    return num - modf(num, &unit) + unit;
}

extern double floorbyunit(double num, double unit) {
    return num - modf(num, &unit);
}

extern float pixel(float num) {
    switch ((int)[UIScreen mainScreen].scale) {
        case 1:
            return roundbyunit(num, 1.0 / 1.0);
            break;
        case 2:
            return roundbyunit(num, 1.0 / 2.0);
            break;
        case 3:
            return roundbyunit(num, 1.0 / 3.0);
            break;
        default:
            return num;
            break;
    }
}

#pragma mark - Action
- (void)tapGesture:(UITapGestureRecognizer *)tap {
    NSLog(@"tap");
    self.userInteractionEnabled = NO;
    UILabel *previousLabel = [_selectedView viewWithTag:_labelTag];
    UIView *newView = tap.view;
    UILabel *newLabel = [newView viewWithTag:_labelTag];
    _selectedView = newView;
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedAtSection:withDuration:)]) {
        [_delegate didSelectedAtSection:newView.tag - _viewTag withDuration:_duration];
    }
    [UIView animateWithDuration:_duration animations:^{
        previousLabel.textColor = _textColor;
        newLabel.textColor = self.tintColor;
//        _indicatorView.frame = CGRectMake(_indicatorView.frame.origin.x,
//                                          _indicatorView.frame.origin.y,
//                                          _items[newView.tag - _viewTag].indicatorWidth,
//                                          _indicatorHeight);
        _indicatorView.center = CGPointMake(newView.center.x, _indicatorView.center.y);
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
}

#pragma mark - Accessor
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    UILabel *previousLabel = [_selectedView viewWithTag:_labelTag];
    UIView *newView = _itemViews[selectedIndex];
    UILabel *newLabel = [newView viewWithTag:_labelTag];
    _selectedView = newView;

    [UIView animateWithDuration:_duration animations:^{
        previousLabel.textColor = _textColor;
        newLabel.textColor = self.tintColor;
        _indicatorView.center = CGPointMake(newView.center.x, _indicatorView.center.y);
        
        CGFloat leftEdge = _scrollView.contentOffset.x;
        CGFloat rightEdge = leftEdge + self.bounds.size.width;
        CGFloat indicatorLeft = _indicatorView.frame.origin.x;
        CGFloat indicatorRight = indicatorLeft + _indicatorView.frame.size.width;
        if (indicatorRight > rightEdge) {
            _scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x + (indicatorRight - rightEdge),
                                                    _scrollView.contentOffset.y);
        } else if (indicatorLeft < leftEdge) {
            _scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x - (leftEdge - indicatorLeft),
                                                    _scrollView.contentOffset.y);
        }
        
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];

}

//- (void)setItemHeight:(CGFloat)itemHeight {
//    _itemHeight = itemHeight;
//    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, _itemHeight + _indicatorHeight);
//    NSLog(@"%s--bar:%@",__func__, self);
//
//}
//
//- (void)setIndicatorHeight:(CGFloat)indicatorHeight {
//    _indicatorHeight = indicatorHeight;
//    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, _itemHeight + _indicatorHeight);
//    NSLog(@"%s--bar:%@",__func__, self);
//}




#pragma mark - Private Methods


@end





















