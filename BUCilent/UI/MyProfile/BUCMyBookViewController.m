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

const NSInteger kBookPageSize = 20;

@interface BUCMyBookViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation BUCMyBookViewController {
    UITableView *_tableView;
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
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [_tableView registerClass:[BUCBookCell class] forCellReuseIdentifier:[BUCBookCell cellReuseIdentifier]];
    [self.view addSubview:_tableView];
    
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

#pragma mark - API
- (void)loadData:(BOOL)isFirst {
    if (isFirst) {
        _page = 0;
//        _dataArray.totalSize = self.tidSum.integerValue + 1;
        _dataArray.totalSize = 20;
        _dataArray.pageSize = kBookPageSize;
    }
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/%@",[BUCNetworkAPI requestURL:kApiFavoriteList],[BUCDataManager sharedInstance].username];
    
    parameters[@"from"] =[NSString stringWithFormat:@"%ld",_page * kBookPageSize];
     parameters[@"to"] = [NSString stringWithFormat:@"%@", @30];
//    parameters[@"to"] = ((_page + 1) * kBookPageSize < _dataArray.totalSize) ? [NSString stringWithFormat:@"%ld",(_page + 1) * kBookPageSize] : [NSString stringWithFormat:@"%ld", (long)_dataArray.totalSize];
    
    [[BUCDataManager sharedInstance] GET:url parameters:parameters attachment:nil isForm:NO configure:nil onError:^(NSString *text) {
        
    } onSuccess:^(NSDictionary *result) {
        NSLog(@"booklist success");
        NSArray *array = [MTLJSONAdapter modelsOfClass:BUCBookModel.class fromJSONArray:[result objectForKey:@"data"] error:Nil];
        [_dataArray addObjectsFromArray:array];
        _page += 1;
        _dataArray.page = _page;
        
        _pullUp = NO;
        _tableView.tableFooterView.hidden = YES;
//        [_footerView stopAnimation];
        [_tableView reloadData];
        
    }];
}

@end
