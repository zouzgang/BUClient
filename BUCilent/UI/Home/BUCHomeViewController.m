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

#import "BUCPostDetailViewController.h"


@interface BUCHomeViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation BUCHomeViewController {
    UITableView *_tableView;
    NSArray <BUCHomeModel *> *_dataArray;
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
    BUCHomeCell *homeCell = [tableView dequeueReusableCellWithIdentifier:[BUCHomeCell cellReuseIdentifier] forIndexPath:indexPath];
    homeCell.homeModel = _dataArray[indexPath.row];
    return homeCell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:[BUCHomeCell cellReuseIdentifier] configuration:^(BUCHomeCell *cell) {
        cell.homeModel = _dataArray[indexPath.row];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BUCPostDetailViewController *detail = [[BUCPostDetailViewController alloc] init];
    detail.tid = _dataArray[indexPath.row].tid;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - API
- (void)loadData {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"username"] = [BUCDataManager sharedInstance].username;
    parameters[@"session"] = [BUCDataManager sharedInstance].session;
    
    [[BUCDataManager sharedInstance] POST:[BUCNetworkAPI requestURL:kApiHome] parameters:parameters attachment:nil isForm:NO onError:^(NSString *text) {
        
    } onSuccess:^(NSDictionary *result) {
        NSLog(@"home success");
         _dataArray = [[MTLJSONAdapter modelsOfClass:BUCHomeModel.class fromJSONArray:[result objectForKey:@"newlist"] error:Nil] mutableCopy];
        [_tableView reloadData];

    }];
}



@end
