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
#import "BUCStringTool.h"
#import "BUCToast.h"
#import "BUCPostDetailModelDealer.h"

const NSInteger kPageSize = 20;

@interface BUCPostDetailViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@end

@implementation BUCPostDetailViewController {
    UITableView *_tableView;
    BUCFooterView *_footerView;
    BUCArray *_dataArray;
    
    NSMutableDictionary *_cacheDict;
    
    NSInteger _page;
    BOOL _reverse;
    BOOL _pullUp;
    
    BOOL _isBook;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataArray = [[BUCArray alloc] init];
        _cacheDict = [NSMutableDictionary dictionary];
        _reverse = NO;
        _pullUp = NO;
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(didReplyButtonClicked)];
    [self loadData];
    
    if (self.tidSum) {
        [self loadData:YES];
    } else {
        [self checkoutTidSum];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BUCPostDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:[BUCPostDetailCell cellReuseIdentifier] forIndexPath:indexPath];
    BUCPostDetailModel *postDetail = _dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.count = !_reverse ? (indexPath.row + 1) : (_tidSum.integerValue - indexPath.row + 1);
    cell.indexPath = indexPath;
    cell.postDetailModel = postDetail;
    cell.attributedString = _cacheDict[postDetail.pid][@"attributedString"];
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BUCPostDetailModel *postDetail = _dataArray[indexPath.row];
    return ((NSNumber *)_cacheDict[postDetail.pid][@"height"]).floatValue;
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
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"username"] = [BUCDataManager sharedInstance].username;
    parameters[@"session"] = [BUCDataManager sharedInstance].session;
    parameters[@"action"] = @"post";
    parameters[@"tid"] = [NSString stringWithFormat:@"%@", self.tid];

    if (!_reverse) {
        parameters[@"from"] =[NSString stringWithFormat:@"%ld",_page * kPageSize];
        parameters[@"to"] = ((_page + 1) * kPageSize < _dataArray.totalSize) ? [NSString stringWithFormat:@"%ld",(_page + 1) * kPageSize] : [NSString stringWithFormat:@"%ld", (long)_dataArray.totalSize];
    } else {
        parameters[@"from"] = ((_page + 1) * kPageSize < _dataArray.totalSize) ? [NSString stringWithFormat:@"%ld",_dataArray.totalSize - (_page + 1) * kPageSize] : [NSString stringWithFormat:@"%ld", (long)0];
        parameters[@"to"] = [NSString stringWithFormat:@"%ld",_dataArray.totalSize - _page * kPageSize];
    }

    
    [[BUCDataManager sharedInstance] POST:[BUCNetworkAPI requestURL:kApiPostDetail] parameters:parameters attachment:nil isForm:NO configure:isFirst ? @{kShowLoadingViewWhenNetwork : @YES} : nil onError:^(NSString *text) {
        
    } onSuccess:^(NSDictionary *result) {
        NSLog(@"detail success");
        self.navigationItem.rightBarButtonItem.enabled = YES;
        NSArray *array = [MTLJSONAdapter modelsOfClass:BUCPostDetailModel.class fromJSONArray:[result objectForKey:@"postlist"] error:Nil];
        if (_reverse) {
            for (NSInteger i = array.count - 1; i >=0; i --) {
                [_dataArray addObject:array[i]];
            }
        } else {
            [_dataArray addObjectsFromArray:array];
        }
    
        _page += 1;
        _dataArray.page = _page;
        
        _pullUp = NO;
        _tableView.tableFooterView.hidden = YES;
        [_footerView stopAnimation];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [BUCPostDetailModelDealer cacheArray:_dataArray cacheMap:_cacheDict];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });
        });
        
    }];
}

- (void)checkoutTidSum {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"%@", self.tid] forKey:@"tid"];
    [parameters setObject:[BUCDataManager sharedInstance].username forKey:@"username"];
    parameters[@"session"] = [BUCDataManager sharedInstance].session;
    
    [[BUCDataManager sharedInstance] POST:[BUCNetworkAPI requestURL:kApiTidOrFid] parameters:parameters attachment:nil isForm:NO configure:nil onError:^(NSString *text) {
        
    } onSuccess:^(NSDictionary *result) {
        self.tidSum = result[@"tid_sum"];
        [self loadData:YES];
    }];
}
- (void)loadData {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"username"] = [BUCDataManager sharedInstance].username;
    parameters[@"tid"] = [NSString stringWithFormat:@"%@", self.tid];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",[BUCNetworkAPI requestURL:kApiFavoriteStatus],[BUCDataManager sharedInstance].username, self.tid];
    
    [[BUCDataManager sharedInstance] GET:url parameters:nil attachment:nil isForm:NO configure:nil onError:^(NSString *text) {
        [BUCToast showToast:text];
    } onSuccess:^(NSDictionary *result) {
        
        _isBook = !(((NSString *)result[@"data"]).integerValue == 0);
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
    NSLog(@"self.view:%@",self.view);
    [filterView showInView:self.view titles:@[@"回复", @"倒序", _isBook ? @"取消收藏": @"收藏"] completehandler:^(NSInteger index) {
        if (index == 0) {
            //reply atuhor
            BUCReplyViewController *reply = [[BUCReplyViewController alloc] init];
            reply.completBlock = ^(NSString *content, UIImage *attachment) {
                
            };
            reply.tid = self.tid;
            [self.navigationController pushViewController:reply animated:NO];
        } else if (index == 1) {
            _reverse = !_reverse;
            [_dataArray removeAllObjects];
            [self loadData:YES];
        } else if (index == 2) {
            if (_isBook) {
                [self deleteBookMark];
            } else {
                [self starPost];
            }

        }
    }];
    
}

- (void)starPost {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"username"] = [BUCDataManager sharedInstance].username;
    parameters[@"subject"] = [BUCStringTool urldecode:self.postTitle];
    parameters[@"author"] = self.author;
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




@end
