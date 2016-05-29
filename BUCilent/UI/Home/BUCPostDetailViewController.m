//
//  BUCPostDetailViewController.m
//  BUCilent
//
//  Created by dito on 16/5/9.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCPostDetailViewController.h"
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

const NSInteger kPageSize = 20;

@interface BUCPostDetailViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, BUCPostDetailCellDelegate>

@end

@implementation BUCPostDetailViewController {
    UITableView *_tableView;
    BUCFooterView *_footerView;
    BUCArray *_dataArray;
    
    NSInteger _page;
    BOOL _reverse;
    BOOL _pullUp;

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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(didReplyButtonClicked)];
    
    
    [self loadData:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BUCPostDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:[BUCPostDetailCell cellReuseIdentifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.count = !_reverse ? (indexPath.row + 1) : (_tidSum.integerValue - indexPath.row);
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
- (void)loadData:(BOOL)isFirst {
    if (isFirst) {
        _page = 0;
        _dataArray.totalSize = self.tidSum.integerValue + 1;
        _dataArray.pageSize = kPageSize;
    }
    
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"username"] = [BUCDataManager sharedInstance].username;
    parameters[@"session"] = [BUCDataManager sharedInstance].session;
    parameters[@"action"] = @"post";
    parameters[@"tid"] = self.tid;
    parameters[@"action"] = @"post";

    if (!_reverse) {
        parameters[@"from"] =[NSString stringWithFormat:@"%ld",_page * kPageSize];
        parameters[@"to"] = ((_page + 1) * kPageSize < _dataArray.totalSize) ? [NSString stringWithFormat:@"%ld",(_page + 1) * kPageSize] : [NSString stringWithFormat:@"%ld", (long)_dataArray.totalSize];
    } else {
        parameters[@"from"] =[NSString stringWithFormat:@"%ld",_dataArray.totalSize];
        parameters[@"to"] = ((_page + 1) * kPageSize < _dataArray.totalSize) ? [NSString stringWithFormat:@"%ld",_dataArray.totalSize - (_page + 1) * kPageSize] : [NSString stringWithFormat:@"%ld", (long)0];
    }

    
    [[BUCDataManager sharedInstance] POST:[BUCNetworkAPI requestURL:kApiPostDetail] parameters:parameters attachment:nil isForm:NO onError:^(NSString *text) {
        
    } onSuccess:^(NSDictionary *result) {
        NSLog(@"detail success");
        NSArray *array = [MTLJSONAdapter modelsOfClass:BUCPostDetailModel.class fromJSONArray:[result objectForKey:@"postlist"] error:Nil];
        [_dataArray addObjectsFromArray:array];
        _page += 1;
        _dataArray.page = _page;
        
        _pullUp = NO;
        _tableView.tableFooterView.hidden = YES;
        [_footerView stopAnimation];
        [_tableView reloadData];
        
    }];
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

#pragma mark - BUCPostDetailCellDelegate
- (void)didClickReplyButtonAtIndexPath:(NSIndexPath *)indexPath {
    //reply some
}

#pragma mark - Action
- (void)didReplyButtonClicked {
    CPEventFilterView *filterView = [[CPEventFilterView alloc] init];
    [filterView showInView:self.tabBarController.view titles:@[@"回复", @"倒序", @"收藏"] completehandler:^(NSInteger index) {
        if (index == 0) {
            //reply atuhor
            BUCReplyViewController *reply = [[BUCReplyViewController alloc] init];
            reply.completBlock = ^(NSString *content, UIImage *attachment) {
                
            };
            reply.tid = self.tid;
            [self.navigationController pushViewController:reply animated:YES];
        } else if (index == 1) {
            _reverse = YES;
            [_dataArray removeAllObjects];
            [self loadData:YES];
        } else if (index == 2) {
            
        }
    }];
    
    

    
}


@end
