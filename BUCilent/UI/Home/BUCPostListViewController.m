//
//  BUCPostListViewController.m
//  BUCilent
//
//  Created by dito on 16/6/1.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCPostListViewController.h"
#import "BUCPostDetailCell.h"
#import "BUCDataManager.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "BUCNetworkAPI.h"
#import "BUCPostDetailModel.h"
#import "BUCArray.h"
#import "BUCFooterView.h"
#import "BUCReplyViewController.h"
#import <Masonry.h>
#import "CPEventFilterView.h"
#import "BUCBookTool.h"

const NSInteger kPostListPageSize = 20;


@interface BUCPostListViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, BUCPostDetailCellDelegate>

@end

@implementation BUCPostListViewController {
    UITableView *_tableView;
    BUCFooterView *_footerView;
    BUCArray *_dataArray;
    
    NSInteger _page;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataArray = [[BUCArray alloc] init];
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
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    [_tableView registerClass:[BUCPostDetailCell class] forCellReuseIdentifier:[BUCPostDetailCell cellReuseIdentifier]];
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

    [self loadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BUCPostDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:[BUCPostDetailCell cellReuseIdentifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.count = (indexPath.row + 1) + _page * kPostListPageSize;
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.postDetailModel = _dataArray[indexPath.row];
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [tableView fd_heightForCellWithIdentifier:[BUCPostDetailCell cellReuseIdentifier] configuration:^(BUCPostDetailCell *cell) {
        cell.postDetailModel = _dataArray[indexPath.row];
    }];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - API
- (void)loadData {

    _dataArray.totalSize = self.tidSum.integerValue + 1;
    _dataArray.pageSize = kPostListPageSize;
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"username"] = [BUCDataManager sharedInstance].username;
    parameters[@"session"] = [BUCDataManager sharedInstance].session;
    parameters[@"action"] = @"post";
    parameters[@"tid"] = [NSString stringWithFormat:@"%@", self.tid];
    
    parameters[@"from"] =[NSString stringWithFormat:@"%ld",_page * kPostListPageSize];
    parameters[@"to"] = ((_page + 1) * kPostListPageSize < _dataArray.totalSize) ? [NSString stringWithFormat:@"%ld",(_page + 1) * kPostListPageSize] : [NSString stringWithFormat:@"%ld", (long)_dataArray.totalSize];
    
    
    [[BUCDataManager sharedInstance] POST:[BUCNetworkAPI requestURL:kApiPostDetail] parameters:parameters attachment:nil isForm:NO configure:@{kShowLoadingViewWhenNetwork : @YES} onError:^(NSString *text) {
        self.networkButton.hidden = NO;
        [self.view bringSubviewToFront:self.networkButton];
    } onSuccess:^(NSDictionary *result) {
        NSLog(@"detail success");
        self.navigationItem.rightBarButtonItem.enabled = YES;
        NSArray *array = [MTLJSONAdapter modelsOfClass:BUCPostDetailModel.class fromJSONArray:[result objectForKey:@"postlist"] error:Nil];
         [_dataArray addObjectsFromArray:array];
    
        _tableView.tableFooterView.hidden = YES;
        [_footerView stopAnimation];
        [_tableView reloadData];
        
    }];
}

#pragma mark - Override
- (void)displayNetworkErrorButton {
    NSLog(@"network error");
}





@end
