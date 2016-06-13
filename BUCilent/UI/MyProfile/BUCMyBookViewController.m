//
//  BUCMyBookViewController.m
//  BUCilent
//
//  Created by dito on 16/5/29.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCMyBookViewController.h"
#import <Masonry.h>
#import "BUCBookTool.h"
#import "BUCStringTool.h"

#import "BUCDataManager.h"
#import "BUCNetworkAPI.h"
#import "BUCPostDetailViewController.h"

#import "BUCSearchModel.h"
#import "BUCArray.h"
#import "BUCBookCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "BUCBookModel.h"
#import "BUCFooterView.h"


const NSInteger kBookPageSize = 20;

@interface BUCMyBookViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@end

@implementation BUCMyBookViewController {
    UITableView *_tableView;
    BUCArray *_dataArray;
    BUCFooterView *_footerView;

    NSInteger _page;
    BOOL _noMore;
    BOOL _pullUp;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"我的收藏";
        _dataArray = [[BUCArray alloc] init];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 44;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [_tableView registerClass:[BUCBookCell class] forCellReuseIdentifier:[BUCBookCell cellReuseIdentifier]];
    [self.view addSubview:_tableView];
    
    _footerView = [[BUCFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    _tableView.tableFooterView = _footerView;
    _tableView.tableFooterView.hidden = YES;
    
    [self updateViewConstraints];
}

- (void)updateViewConstraints {
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [super updateViewConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BUCBookCell *bookCell = [tableView dequeueReusableCellWithIdentifier:[BUCBookCell cellReuseIdentifier] forIndexPath:indexPath];
    bookCell.bookModel = _dataArray[indexPath.row];
    
    return bookCell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:[BUCBookCell cellReuseIdentifier] configuration:^(BUCBookCell *cell) {
        cell.bookModel = _dataArray[indexPath.row];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BUCPostDetailViewController *detail = [[BUCPostDetailViewController alloc] init];
    detail.tid = @(((BUCBookModel *)_dataArray[indexPath.row]).tid.intValue);
    detail.postTitle = ((BUCBookModel *)_dataArray[indexPath.row]).postTitle;
    detail.author = ((BUCBookModel *)_dataArray[indexPath.row]).author;
    [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - UIScroviewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_pullUp == NO && scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height + 50) && !_noMore) {
        
        _tableView.tableFooterView.hidden = NO;
        if ([_dataArray hasMore]) {
            [_footerView startAnimation];
            [self loadData:NO];
        } else {
            [_footerView showText];
        }
    }
}

#pragma mark - API
- (void)loadData:(BOOL)isFirst {
    if (isFirst) {
        _page = 0;
        _dataArray.totalSize = 20;
        _dataArray.pageSize = kBookPageSize;
    }
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/%@",[BUCNetworkAPI requestURL:kApiFavoriteList],[BUCDataManager sharedInstance].username];
    
    parameters[@"from"] =[NSString stringWithFormat:@"%ld",_page * kBookPageSize];
     parameters[@"to"] = [NSString stringWithFormat:@"%ld",(_page + 1) * kBookPageSize];
    
    [[BUCDataManager sharedInstance] GET:url parameters:parameters attachment:nil isForm:NO configure:nil onError:^(NSString *text) {
        
    } onSuccess:^(NSDictionary *result) {
        NSLog(@"booklist success");
        NSArray *array = [MTLJSONAdapter modelsOfClass:BUCBookModel.class fromJSONArray:[result objectForKey:@"data"] error:Nil];
        [_dataArray addObjectsFromArray:array];
        if (array.count < kBookPageSize)
            _noMore = YES;
        
        _page += 1;
        _dataArray.page = _page;
        
        _pullUp = NO;
        _tableView.tableFooterView.hidden = YES;
        [_footerView stopAnimation];
        [_tableView reloadData];
        
    }];
}

@end
