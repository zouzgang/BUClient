//
//  BUCMyProfileViewController.m
//  BUCilent
//
//  Created by dito on 16/5/8.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCMyProfileViewController.h"
#import <Masonry.h>
#import "BUCMyBookViewController.h"
#import "BUCToast.h"
#import "UIColor+BUC.h"
#import "CPMailCompose.h"
#import "BUCDataManager.h"
#import "BUCNetworkAPI.h"
#import "AppDelegate.h"
#import "BUCLoginViewController.h"

@interface BUCMyProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation BUCMyProfileViewController {
    UITableView *_tableView;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"我";
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 44;
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
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1 || section == 2) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
  
    if (indexPath.section == 0) {
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"我的收藏";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"我的消息";
        }
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"意见反馈";
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }else if (indexPath.section == 2) {
        cell.textLabel.text = @"退出";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            BUCMyBookViewController *myBook = [[BUCMyBookViewController alloc] init];
            myBook.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myBook animated:YES];
        } else if (indexPath.row == 1) {
            [BUCToast showToast:@"Todo"];
        }
    
    } else if (indexPath.section == 1) {
        NSMutableString *messageBody = [[NSString stringWithFormat:@"\n\n\n\n iOS%@, ",[[UIDevice currentDevice] systemVersion]] mutableCopy];
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
        
        [messageBody appendFormat:@"%@ %@.%@, %@",app_Name, app_Version, app_build, [BUCDataManager sharedInstance].username];
        
        
        NSString *subject = [NSString stringWithFormat:@"%@ %@",@"意见反馈", app_Name];
        NSArray *toRecipients = @[@"836090206@qq.com"];
        [[CPMailCompose sharedInstance] send:subject toRecipients:toRecipients messageBody:[messageBody copy] isHTML:NO controller:self];
        
    } else {
        //退出登陆
        [self logout];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 16;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    return header;
}

#pragma mark - Action
- (void)logout {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@"logout" forKey:@"action"];
    [parameters setObject:[BUCDataManager sharedInstance].username forKey:@"username"];
    [parameters setObject:[BUCDataManager sharedInstance].session forKey:@"session"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *password = [defaults stringForKey:@"password"];
    [parameters setObject:password forKey:@"password"];
    
    [[BUCDataManager sharedInstance] POST:[BUCNetworkAPI requestURL:kApiLogin] parameters:parameters attachment:nil isForm:NO configure:@{kShowLoadingViewWhenNetwork : @YES}  onError:^(NSString *text) {
        [BUCToast showToast:text];
    } onSuccess:^(NSDictionary *result) {
        NSLog(@"logout success");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"" forKey:@"username"];
        [defaults setObject:@"" forKey:@"password"];
        [defaults synchronize];
        
        AppDelegate *delagte = [UIApplication sharedApplication].delegate;
        BUCLoginViewController *login = [[BUCLoginViewController alloc] init];
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:login];
        delagte.window.rootViewController = navigation;
        [delagte.window makeKeyAndVisible];
    }];
}



@end
