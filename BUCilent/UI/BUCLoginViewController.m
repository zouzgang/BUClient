//
//  BUCLoginViewController.m
//  BUCilent
//
//  Created by dito on 16/5/9.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCLoginViewController.h"
#import "BUCLoadingView.h"
#import <Masonry.h>
#import "NSString+Tools.h"
#import "BUCDataManager.h"
#import "BUCNetworkAPI.h"
#import "BUCTabViewController.h"
#import "AppDelegate.h"

@interface BUCLoginViewController ()

@end

@implementation BUCLoginViewController {
    UITextField *_usernameTextField;
    UITextField *_passwordTextField;
    UIButton *_loginButton;
    BUCLoadingView *_loadingView;
}

#pragma mark - UIViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"登陆";
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    _usernameTextField = [[UITextField alloc] init];
    _usernameTextField.placeholder = @"请输入用户名";
    _usernameTextField.font = [UIFont systemFontOfSize:16];
    _usernameTextField.borderStyle =  UITextBorderStyleRoundedRect;
    [self.view addSubview:_usernameTextField];
    
    _passwordTextField = [[UITextField alloc] init];
    _passwordTextField.placeholder = @"请输入密码";
    _passwordTextField.borderStyle =  UITextBorderStyleRoundedRect;
    _passwordTextField.font = [UIFont systemFontOfSize:16];
    _passwordTextField.secureTextEntry = YES;
    [self.view addSubview:_passwordTextField];
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginButton.layer.masksToBounds = YES;
    _loginButton.layer.cornerRadius = 4;
    _loginButton.backgroundColor = [UIColor greenColor];
    _loginButton.titleLabel.textColor = [UIColor blackColor];
    _loginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(didLoginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    
    
    [self updateViewConstraints];
}

- (void)updateViewConstraints {
    [_usernameTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(160);
        make.left.equalTo(self.view).offset(24);
        make.right.equalTo(self.view).offset(-24);
        make.height.mas_equalTo(32);
    }];
    
    [_passwordTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_usernameTextField.mas_bottom).offset(12);
        make.left.equalTo(self.view).offset(24);
        make.right.equalTo(self.view).offset(-24);
        make.height.mas_equalTo(32);

    }];
    
    [_loginButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTextField.mas_bottom).offset(24);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(100);
    }];
    
    [_loadingView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [super updateViewConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults stringForKey:@"username"];
    NSString *password = [defaults stringForKey:@"password"];
    if (username && password) {
        [self loginWithUsername:username password:password];
    }
    
}

#pragma mark -Action
- (void)didLoginButtonClick {
    NSLog(@"---------username:%@",_usernameTextField.text);
    if (_usernameTextField.text == nil || [_usernameTextField.text isEqualToString:@""]) {
        return;
    }
    if (_passwordTextField.text == nil || [_passwordTextField.text isEqualToString:@""]) {
        return;
    }
    [self loginWithUsername:_usernameTextField.text password:_passwordTextField.text];
    
}

#pragma mark - API
- (void)loginWithUsername:(NSString *)username password:(NSString *)password {
    [self displayLoginView];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@"login" forKey:@"action"];
    [parameters setObject:username forKey:@"username"];
    [parameters setObject:password forKey:@"password"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:username forKey:@"username"];
    [defaults setObject:password forKey:@"password"];
    [defaults synchronize];

    [[BUCDataManager sharedInstance] POST:[BUCNetworkAPI requestURL:kApiLogin] parameters:parameters attachment:nil isForm:NO onError:^(NSString *text) {
        
    } onSuccess:^(NSDictionary *result) {
        NSLog(@"login success");
        AppDelegate *delagte = [UIApplication sharedApplication].delegate;
        delagte.window.rootViewController = [[BUCTabViewController alloc] init];
        [delagte.window makeKeyAndVisible];
    }];
    
}

#pragma  mark - Private Methods
- (void)displayLoginView {
    _loadingView.hidden = NO;
    [_loadingView startAnimation];
    [self.view endEditing:YES];
    [self.view bringSubviewToFront:_loadingView];
}

- (void)hideLoginView {
    [_loadingView stopAnimation];
    _loadingView.hidden = YES;
}

@end
