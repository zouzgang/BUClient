//
//  BUCDiscoverViewController.m
//  BUCilent
//
//  Created by dito on 16/5/8.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCDiscoverViewController.h"
#import <Masonry.h>
#import "BUCDataManager.h"
#import "BUCNetworkAPI.h"

@interface BUCDiscoverViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation BUCDiscoverViewController {
    UITableView *_tableView;
    NSMutableArray *_forumList;
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.rowHeight = 60;
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
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"BITFavoriteList.plist" ofType:nil];
    _forumList = [NSMutableArray arrayWithContentsOfFile:path];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [_forumList[indexPath.row] objectForKey:@"name"];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    
    return cell;
}


#pragma mark - TableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//    [parameters setObject:@"login" forKey:@"tid"];
//    [parameters setObject:[BUCDataManager sharedInstance].username forKey:@"username"];
//
//
//    [[BUCDataManager sharedInstance] POST:[BUCNetworkAPI requestURL:kApiLogin] parameters:parameters attachment:nil isForm:NO onError:^(NSString *text) {
//        
//    } onSuccess:^(NSDictionary *result) {
//        
//    }];
    
    
}






@end
