//
//  ZZGPagerViewController.m
//  ZZGViewPager
//
//  Created by dito on 16/4/18.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "ZZGPagerViewController.h"
#import "ZZGFlowLayout.h"
#import "ZZGCollectionViewCell.h"
#import "ZZGTabBar.h"

@interface ZZGPagerViewController () <UICollectionViewDelegate, UICollectionViewDataSource, ZZGTabBarDelegate>

@end

@implementation ZZGPagerViewController {
    UICollectionView *_collectionView;
    ZZGFlowLayout *_flowLayout;
    
    NSMutableArray *_titles;
    NSMutableArray <UIView *>*_customViews;
    NSMutableArray <UIViewController *>*_controllers;
    
    NSUInteger _count;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _titles = [NSMutableArray array];
        _controllers = [NSMutableArray array];
        _customViews = [NSMutableArray array];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [self defaultSetting];
    }
    return self;
}

- (void)defaultSetting {
    _textColor = [UIColor grayColor];
    _itemFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    _itemHeight = 36;
    _itemWidth = 80;
    _indicatorHeight = 2;
}

- (void)loadView {
    [super loadView];
    self.navigationController.navigationBar.translucent = NO;
    
    _flowLayout = [[ZZGFlowLayout alloc] init];
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _pageBar = [[ZZGTabBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _itemHeight + _indicatorHeight)];
    _pageBar.delegate = self;
    _pageBar.titles = _titles.copy;
    _pageBar.itemHeight = _itemHeight;
    _pageBar.indicatorHeight = _indicatorHeight;
    _pageBar.textColor = _textColor;
    _pageBar.itemFont = _itemFont;
    _pageBar.itemWidth = _itemWidth;
    [_pageBar reloadViews];
    [self.view addSubview:_pageBar];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageBar.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(_pageBar.frame)) collectionViewLayout:_flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.scrollEnabled = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.bounces = NO;
    _collectionView.decelerationRate = 0;
    _collectionView.backgroundColor = [UIColor yellowColor];
    [_collectionView registerClass:[ZZGCollectionViewCell class] forCellWithReuseIdentifier:[ZZGCollectionViewCell cellReuseIdentifier]];
    _collectionView.contentSize = CGSizeMake(_titles.count * self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(_pageBar.frame) - 64/* - 60*/);
    [self.view addSubview:_collectionView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

#pragma mark - UICollectionViewDataSource
- (void)didSelectAtIndex:(NSUInteger)index {
    _collectionView.contentOffset = CGPointMake(self.view.frame.size.width * index, -20);
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _titles.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZZGCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ZZGCollectionViewCell cellReuseIdentifier] forIndexPath:indexPath];
    [cell addSubview:_controllers[indexPath.section].view];
    
    return cell;
}


#pragma mark - ZZGTabBarDelegate
- (void)didSelectedAtSection:(NSInteger)section withDuration:(NSTimeInterval)duration {
    _collectionView.contentOffset = CGPointMake(self.view.frame.size.width * section, 0);
    if (_delegate && [_delegate respondsToSelector:@selector(pagerViewController:didSelectTabAtIndex:)]) {
        [_delegate pagerViewController:self didSelectTabAtIndex:section];
    }
}


#pragma mark - ScrollViewDeleagate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {    
    NSUInteger index = roundf(scrollView.contentOffset.x / self.view.frame.size.width);
    if (_delegate && [_delegate respondsToSelector:@selector(pagerViewController:didSelectTabAtIndex:)]) {
        [_delegate pagerViewController:self didSelectTabAtIndex:index];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSUInteger index = roundf(scrollView.contentOffset.x / self.view.frame.size.width);
    _pageBar.selectedIndex = index;
}


#pragma mark - Public Methods
- (void)selectTabIndex:(NSUInteger)index {
     _collectionView.contentOffset = CGPointMake(self.view.frame.size.width * index, 0);
}


#pragma mark - ZZGPagerViewControllerDelegate


#pragma mark - ZZGPagerViewControllerDataSource  &&  Accessor
- (void)setDataSource:(id<ZZGPagerViewControllerDataSource>)dataSource {
    _dataSource = dataSource;
    
    _count = [_dataSource numberOfViewControllers:self];
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(pagerViewController:viewControllerAtIndex:)]) {
        for (NSInteger index = 0; index < _count; index ++) {
            [_controllers addObject:[_dataSource pagerViewController:self viewControllerAtIndex:index]];
        }
    }
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(pagerViewController:titleAtIndex:)]) {
        for (NSInteger index = 0; index < _count; index ++) {
            [_titles addObject:[_dataSource pagerViewController:self titleAtIndex:index]];
        }
    }
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(pagerViewController:customViewAtIndex:)]) {
        for (NSInteger index = 0; index < _count; index ++) {
            [_customViews addObject:[_dataSource pagerViewController:self customViewAtIndex:index]];
        }
    }
}






@end
