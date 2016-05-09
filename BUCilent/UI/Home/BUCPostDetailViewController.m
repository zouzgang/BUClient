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

#import <Masonry.h>

@interface BUCPostDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation BUCPostDetailViewController {
    UITableView *_tableView;
    NSArray *_dataArray;

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
    [_tableView registerClass:[BUCPostDetailCell class] forCellReuseIdentifier:[BUCPostDetailCell cellReuseIdentifier]];
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
    
    [self loadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BUCPostDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:[BUCPostDetailCell cellReuseIdentifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.postDetailModel = _dataArray[indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 600;
    CGFloat height = [tableView fd_heightForCellWithIdentifier:[BUCPostDetailCell cellReuseIdentifier] configuration:^(BUCPostDetailCell *cell) {
        cell.postDetailModel = _dataArray[indexPath.row];
    }];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - API
- (void)loadData {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"username"] = [BUCDataManager sharedInstance].username;
    parameters[@"session"] = [BUCDataManager sharedInstance].session;
    parameters[@"action"] = @"post";
    parameters[@"tid"] = self.tid;
    parameters[@"action"] = @"post";
    parameters[@"from"] = @"0";
    parameters[@"to"] = @"3";
    
    [[BUCDataManager sharedInstance] POST:[BUCNetworkAPI requestURL:kApiPostDetail] parameters:parameters attachment:nil isForm:NO onError:^(NSString *text) {
        
    } onSuccess:^(NSDictionary *result) {
        NSLog(@"detail success");
        _dataArray = [[MTLJSONAdapter modelsOfClass:BUCPostDetailModel.class fromJSONArray:[result objectForKey:@"postlist"] error:Nil] mutableCopy];
//        _dataArray = [[MTLJSONAdapter modelsOfClass:BUCHomeModel.class fromJSONArray:[result objectForKey:@"newlist"] error:Nil] mutableCopy];
        [_tableView reloadData];
        
    }];
}




@end
