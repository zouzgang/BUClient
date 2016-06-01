//
//  BUCForumListViewController.m
//  BUCilent
//
//  Created by dito on 16/5/29.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCForumListViewController.h"
#import "BUCForumCell.h"
#import "BUCForumModel.h"
#import "BUCArray.h"
#import "BUCDataManager.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "BUCNetworkAPI.h"
#import <Masonry.h>
#import "BUCFooterView.h"
#import "BUCPostDetailViewController.h"

const NSInteger kForumListPageSize = 20;

@interface BUCForumListViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@end

@implementation BUCForumListViewController {
    UITableView *_tableView;
    BUCFooterView *_footerView;

    BUCArray  *_dataArray;
    BOOL _pullUp;
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
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [_tableView registerClass:[BUCForumCell class] forCellReuseIdentifier:[BUCForumCell cellReuseIdentifier]];
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
    BUCForumCell *cell = [tableView dequeueReusableCellWithIdentifier:[BUCForumCell cellReuseIdentifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.forumModel = _dataArray[indexPath.row];
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [tableView fd_heightForCellWithIdentifier:[BUCForumCell cellReuseIdentifier] configuration:^(BUCForumCell *cell) {
        cell.forumModel = _dataArray[indexPath.row];
    }];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BUCForumModel *forumModel = ((BUCForumModel *)_dataArray[indexPath.row]);
    
    BUCPostDetailViewController *detail = [[BUCPostDetailViewController alloc] init];
    detail.tid = forumModel.tid;
    detail.tidSum = @(forumModel.replies.integerValue);
    detail.postTitle = forumModel.subject;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - UIScroviewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_pullUp == NO && scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height + 50)) {
        
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
        _dataArray.totalSize = 500; //todo ,需要查询板块帖子主体数量，此处省略这个查询，默认板块帖子主体数大雨500
        _dataArray.pageSize = kForumListPageSize;
    }
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"username"] = [BUCDataManager sharedInstance].username;
    parameters[@"session"] = [BUCDataManager sharedInstance].session;
    parameters[@"action"] = @"thread";
    parameters[@"fid"] = [NSString stringWithFormat:@"%@", self.fid];
    
    parameters[@"from"] =[NSString stringWithFormat:@"%ld",_page * kForumListPageSize];
    parameters[@"to"] = ((_page + 1) * kForumListPageSize < _dataArray.totalSize) ? [NSString stringWithFormat:@"%ld",(_page + 1) * kForumListPageSize] : [NSString stringWithFormat:@"%ld", (long)_dataArray.totalSize];
    
    
    
    [[BUCDataManager sharedInstance] POST:[BUCNetworkAPI requestURL:kApiThread] parameters:parameters attachment:nil isForm:NO onError:^(NSString *text) {
        
    } onSuccess:^(NSDictionary *result) {
        NSLog(@"forum list success");
        self.navigationItem.rightBarButtonItem.enabled = YES;
        NSArray *array = [MTLJSONAdapter modelsOfClass:BUCForumModel.class fromJSONArray:[result objectForKey:@"threadlist"] error:Nil];
        [_dataArray addObjectsFromArray:array];
        
        self.navigationItem.title = [NSString stringWithFormat:@"%@[%lu-%lu]",self.forumName, 0, (_page + 1) * kForumListPageSize];
        
        _pullUp = NO;
        _page += 1;
        _dataArray.page = _page;
        
        _tableView.tableFooterView.hidden = YES;
        [_footerView stopAnimation];
        [_tableView reloadData]; 
    }];
}



@end
