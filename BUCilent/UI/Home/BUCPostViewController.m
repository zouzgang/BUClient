//
//  BUCPostViewController.m
//  BUCilent
//
//  Created by dito on 16/6/1.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCPostViewController.h"
#import "ZZGPagerViewController.h"
#import "BUCPostListViewController.h"


@interface BUCPostViewController () <ZZGPagerViewControllerDataSource, ZZGPagerViewControllerDelegate>

@end

@implementation BUCPostViewController {
     ZZGPagerViewController *_pagerViewController;
    
    NSArray *_dataArray;
}

- (instancetype)initWithPostTitle:(NSString *)postTitle tid:(NSNumber *)tid tidSum:(NSNumber *)tidSum {
    self = [super init];
    if (self) {
        _postTitle = postTitle;
        _tid = tid;
        _tidSum = tidSum;
        
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSInteger i = 0; i < tidSum.integerValue / kPostListPageSize + 1; i ++) {
            [arrayM addObject:[NSString stringWithFormat:@"%ldF",i + 1]];
        }
        _dataArray = arrayM.copy;

    }
    return self;
}


- (void)loadView {
    [super loadView];
    
    _pagerViewController = [[ZZGPagerViewController alloc] init];
    _pagerViewController.dataSource = self;
    _pagerViewController.delegate = self;
    _pagerViewController.itemFont = [UIFont systemFontOfSize:16];
    _pagerViewController.textColor = [UIColor blackColor];
    _pagerViewController.itemHeight = 32;
    _pagerViewController.itemWidth = 60;
    _pagerViewController.indicatorHeight = 2;
    _pagerViewController.view.frame = self.view.frame;
    [self.view addSubview:_pagerViewController.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - ZZGPagerViewControllerDelegate
- (void)pagerViewController:(ZZGPagerViewController *)pagerViewController didSelectTabAtIndex:(NSUInteger)index {
    NSLog(@"didselect index :%d",index);
}


#pragma mark - ZZGPagerViewControllerDataSource
- (NSInteger)numberOfViewControllers:(ZZGPagerViewController *)pagerViewController {
    return _dataArray.count;
}

- (NSString *)pagerViewController:(ZZGPagerViewController *)pagerViewController titleAtIndex:(NSInteger)index {
    return _dataArray[index];
}

- (UIViewController *)pagerViewController:(ZZGPagerViewController *)pagerViewController viewControllerAtIndex:(NSInteger)index {
    BUCPostListViewController *postList = [[BUCPostListViewController alloc] init];
    postList.tidSum = self.tidSum;
    postList.tid = self.tid;
    postList.postTitle = self.postTitle;
    postList.page = index;
    
    return postList;
}




@end
