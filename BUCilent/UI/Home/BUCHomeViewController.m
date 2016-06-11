//
//  BUCHomeViewController.m
//  BUCilent
//
//  Created by dito on 16/5/8.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCHomeViewController.h"
#import "BUCHomeCell.h"
#import <Masonry.h>
#import "UITableView+FDTemplateLayoutCell.h"
#import "BUCDataManager.h"
#import "BUCNetworkAPI.h"
#import "BUCHomeModel.h"
#import "BUCFooterView.h"

#import "BUCPostDetailViewController.h"
#import "UIScrollView+BUCPullToRefresh.h"
#import "BUCPostViewController.h"
#import "BUCToast.h"
#import "BUCNewPostViewController.h"
#import "PresentAntimator.h"
#import "UIColor+BUC.h"
#import "BUCSearchModel.h"
#import "BUCArray.h"
#import "BUCBookCell.h"
#import "BUCBookModel.h"

@interface BUCHomeViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@end

@implementation BUCHomeViewController {
    UITableView *_tableView;
    NSArray <BUCHomeModel *> *_dataArray;
    
    BOOL _pullDown;
    
    UISearchBar *_searchBar;
    UISearchDisplayController *_searchDisplayController;
    BUCArray *_searchResultList;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataArray = [[NSArray alloc] init];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 44;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [_tableView registerClass:[BUCHomeCell class] forCellReuseIdentifier:[BUCHomeCell cellReuseIdentifier]];
    [self.view addSubview:_tableView];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    _searchBar.placeholder = @"搜索";
    _searchBar.delegate = self;
    _searchBar.backgroundColor = [UIColor whiteColor];
    _searchBar.searchBarStyle = UISearchBarStyleProminent;
    _searchBar.tintColor = [UIColor blueColor];
    _searchBar.barTintColor = [UIColor colorWithHexString:@"#F3F3F3"];
    _searchBar.layer.borderWidth = 0.3;
    _searchBar.layer.borderColor = [UIColor colorWithHexString:@"#F3F3F3"].CGColor;
    [self.view addSubview:_searchBar];
    
    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
//    _searchDisplayController.delegate = self;
    _searchDisplayController.searchResultsDataSource = self;
    _searchDisplayController.searchResultsDelegate = self;
    _searchDisplayController.searchResultsTableView.backgroundColor = [UIColor whiteColor];
    _searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _searchDisplayController.searchResultsTableView.tableFooterView = [UIView new];
    [_searchDisplayController.searchResultsTableView registerClass:[BUCBookCell class] forCellReuseIdentifier:[BUCBookCell cellReuseIdentifier]];
    
    [self updateViewConstraints];
}

- (void)updateViewConstraints {
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(45, 0, 0, 0));
    }];
    
    [super updateViewConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"BIT LM";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didRightBarClick)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(didLeftBarClick)];
    
    __weak BUCHomeViewController *weakSelf = self;
    [_tableView addPullToRefreshActionHandler:^{
        NSLog(@"pull to refresh");
        [weakSelf loadData];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _searchDisplayController.searchResultsTableView) {
        return [self searchResultTableView:tableView numberOfRowsInSection:section];
    }
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _searchDisplayController.searchResultsTableView) {
        return [self searchResultTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    BUCHomeCell *homeCell = [tableView dequeueReusableCellWithIdentifier:[BUCHomeCell cellReuseIdentifier] forIndexPath:indexPath];
    homeCell.homeModel = _dataArray[indexPath.row];
    return homeCell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _searchDisplayController.searchResultsTableView) {
        return [tableView fd_heightForCellWithIdentifier:[BUCBookCell cellReuseIdentifier] configuration:^(BUCBookCell *cell) {
            cell.searchModel = _searchResultList[indexPath.row];
        }];
    }
    return [tableView fd_heightForCellWithIdentifier:[BUCHomeCell cellReuseIdentifier] configuration:^(BUCHomeCell *cell) {
        cell.homeModel = _dataArray[indexPath.row];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == _searchDisplayController.searchResultsTableView) {
        BUCBookModel *bookModel = _searchResultList[indexPath.row];
        BUCPostDetailViewController *detail = [[BUCPostDetailViewController alloc] init];
        detail.tid = @(bookModel.tid.intValue);
        detail.postTitle = bookModel.postTitle;
        detail.author = ((BUCBookModel *)_dataArray[indexPath.row]).author;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
        return;
    }
    
    BUCPostViewController *detail = [[BUCPostViewController alloc] initWithPostTitle:_dataArray[indexPath.row].pname author:_dataArray[indexPath.row].author tid:_dataArray[indexPath.row].tid tidSum:_dataArray[indexPath.row].tidSum];
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - API
- (void)loadData {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"username"] = [BUCDataManager sharedInstance].username;
    parameters[@"session"] = [BUCDataManager sharedInstance].session;
    
    [[BUCDataManager sharedInstance] POST:[BUCNetworkAPI requestURL:kApiHome] parameters:parameters attachment:nil isForm:NO configure:nil onError:^(NSString *text) {
        _pullDown = NO;
        
    } onSuccess:^(NSDictionary *result) {
        NSLog(@"home success");
         _dataArray = [[MTLJSONAdapter modelsOfClass:BUCHomeModel.class fromJSONArray:[result objectForKey:@"newlist"] error:Nil] mutableCopy];
        _pullDown = NO;
        if (_tableView.pullToRefreshView.state == BUCPullToRefreshStateLoading) {
            [_tableView.pullToRefreshView stopAnimating];
        }
        [_tableView reloadData];

    }];
}


#pragma mark - Action
- (void)didRightBarClick {
    BUCNewPostViewController *newPost = [[BUCNewPostViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:newPost];
    newPost.modalPresentationStyle = UIModalPresentationPageSheet;
    
    PresentAntimator *animator = [[PresentAntimator alloc] initWithModalViewController:newPost];
    animator.bounces = NO;
    animator.behindViewAlpha = 0.9f;
    animator.behindViewScale = 0.8f;
    animator.transitionDuration = 1;
    
    nav.transitioningDelegate = animator;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didLeftBarClick {
    [BUCToast showToast:@"Todo"];
}

#pragma mark - UISearchDisplayController UITableViewDataSource
- (NSInteger)searchResultTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchResultList.count;
}

- (UITableViewCell *)searchResultTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BUCBookCell *searchCell = [tableView dequeueReusableCellWithIdentifier:[BUCBookCell cellReuseIdentifier] forIndexPath:indexPath];
    searchCell.searchModel = _searchResultList[indexPath.row];
    
    return searchCell;
}


#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
}

- (void)searchBarSearchButonClicked:(UISearchBar *)searchBar {
    _searchResultList = [[BUCArray alloc] init];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"from"] = [NSString stringWithFormat:@"%@", @0];
    parameters[@"to"] = [NSString stringWithFormat:@"%@", @30];
    parameters[@"key"] = searchBar.text;
    
    [[BUCDataManager sharedInstance] GET:[BUCNetworkAPI requestURL:kApiSearchThreads] parameters:parameters attachment:nil isForm:NO configure:@{kShowLoadingViewWhenNetwork : @YES} onError:^(NSString *text) {
        _pullDown = NO;
        
    } onSuccess:^(NSDictionary *result) {
        NSArray *array = [MTLJSONAdapter modelsOfClass:BUCSearchModel.class fromJSONArray:result[@"data"] error:Nil];
        [_searchResultList addObjectsFromArray:array];
        [_tableView reloadData];
        NSLog(@"search success");
    }];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
