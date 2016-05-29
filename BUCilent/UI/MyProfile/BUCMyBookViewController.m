//
//  BUCMyBookViewController.m
//  BUCilent
//
//  Created by dito on 16/5/29.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCMyBookViewController.h"
#import <Masonry.h>
#import "BUCBookModel.h"
#import "BUCBookTool.h"
#import "BUCStringTool.h"

#import "BUCDataManager.h"
#import "BUCNetworkAPI.h"
#import "BUCPostDetailViewController.h"

@interface BUCMyBookViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation BUCMyBookViewController {
    UITableView *_tableView;
    NSArray<BUCBookModel *> *_dataArray;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    _tableView.estimatedRowHeight = 44;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
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
    
    _dataArray = [BUCBookTool bookList];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [BUCStringTool urldecode:_dataArray[indexPath.row].title];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:_dataArray[indexPath.row].tid forKey:@"tid"];
    [parameters setObject:[BUCDataManager sharedInstance].username forKey:@"username"];
    parameters[@"session"] = [BUCDataManager sharedInstance].session;
    
    
    [[BUCDataManager sharedInstance] POST:[BUCNetworkAPI requestURL:kApiTidOrFid] parameters:parameters attachment:nil isForm:NO onError:^(NSString *text) {
        
    } onSuccess:^(NSDictionary *result) {
        BUCPostDetailViewController *detail = [[BUCPostDetailViewController alloc] init];
        detail.tid = @(_dataArray[indexPath.row].tid.intValue);
        detail.tidSum = result[@"tid_sum"];
        detail.postTitle = _dataArray[indexPath.row].title;
        [self.navigationController pushViewController:detail animated:YES];
    }];

}

@end
