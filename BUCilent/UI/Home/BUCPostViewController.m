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
#import "BUCReplyViewController.h"
#import "BUCBookTool.h"
#import "BUCDataManager.h"
#import "BUCNetworkAPI.h"
#import "BUCToast.h"
#import "CPEventFilterView.h"
#import "BUCStringTool.h"

@interface BUCPostViewController () <ZZGPagerViewControllerDataSource, ZZGPagerViewControllerDelegate>

@end

@implementation BUCPostViewController {
     ZZGPagerViewController *_pagerViewController;
    
    NSArray *_dataArray;
    BOOL _isBook;
}

- (instancetype)initWithPostTitle:(NSString *)postTitle author:(NSString *)author tid:(NSNumber *)tid tidSum:(NSNumber *)tidSum {
    self = [super init];
    if (self) {
        _postTitle = postTitle;
        _tid = tid;
        _tidSum = tidSum;
        _author = author;
        
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
    _pagerViewController.itemWidth = 50;
    _pagerViewController.indicatorHeight = 2;
    _pagerViewController.view.frame = self.view.frame;
    [self.view addSubview:_pagerViewController.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(didNaviRightButtonClicked)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self loadData];
}

- (void)loadData {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"username"] = [BUCDataManager sharedInstance].username;
    parameters[@"tid"] = [NSString stringWithFormat:@"%@", self.tid];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",[BUCNetworkAPI requestURL:kApiFavoriteStatus],[BUCDataManager sharedInstance].username, self.tid];
    
    [[BUCDataManager sharedInstance] GET:url parameters:nil attachment:nil isForm:NO configure:nil onError:^(NSString *text) {
        [BUCToast showToast:text];
    } onSuccess:^(NSDictionary *result) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        _isBook = !(((NSString *)result[@"data"]).integerValue == 0);
    }];
}

#pragma mark - ZZGPagerViewControllerDelegate
- (void)pagerViewController:(ZZGPagerViewController *)pagerViewController didSelectTabAtIndex:(NSUInteger)index {
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

#pragma mark - Action

- (void)starPost {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"username"] = [BUCDataManager sharedInstance].username;
    parameters[@"subject"] = [BUCStringTool urldecode:self.postTitle];
    parameters[@"author"] = [BUCStringTool urldecode:self.author];
    parameters[@"tid"] = [NSString stringWithFormat:@"%@", self.tid];
    
    
    [[BUCDataManager sharedInstance] POST:[BUCNetworkAPI requestURL:kApiFavorite] parameters:parameters attachment:nil isForm:NO configure:nil onError:^(NSString *text) {
        [BUCToast showToast:text];
    } onSuccess:^(NSDictionary *result) {
        [BUCToast showToast:@"已收藏"];
        _isBook = YES;
    }];
}

- (void)deleteBookMark {
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",[BUCNetworkAPI requestURL:kApiFavorite],[BUCDataManager sharedInstance].username, self.tid];
    [[BUCDataManager sharedInstance] DELETE:url parameters:nil attachment:nil isForm:NO configure:nil onError:^(NSString *text) {
        [BUCToast showToast:text];
    } onSuccess:^(NSDictionary *result) {
        [BUCToast showToast:@"取消收藏"];
        _isBook = NO;
    }];
}

- (void)didReplyClick {
    BUCReplyViewController *reply = [[BUCReplyViewController alloc] init];
    reply.completBlock = ^(NSString *content, UIImage *attachment) {
        
    };
    reply.tid = self.tid;
    [self.navigationController pushViewController:reply animated:NO];

}

- (void)didNaviRightButtonClicked {
    CPEventFilterView *filterView = [[CPEventFilterView alloc] init];
    NSLog(@"self.view:%@",self.view);
    [filterView showInView:self.view titles:@[@"回复", _isBook ? @"取消收藏": @"收藏"] completehandler:^(NSInteger index) {
        if (index == 0) {
            //reply atuhor
            BUCReplyViewController *reply = [[BUCReplyViewController alloc] init];
            reply.completBlock = ^(NSString *content, UIImage *attachment) {
                
            };
            reply.tid = self.tid;
            [self.navigationController pushViewController:reply animated:NO];
        } else if (index == 1) {

            if (_isBook) {
                [self deleteBookMark];
            } else {
                [self starPost];
            }
        }
    }];
}





@end
