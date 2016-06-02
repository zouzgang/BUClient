//
//  BUCBaseViewController.m
//  BUCilent
//
//  Created by dito on 16/5/8.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCBaseViewController.h"
#import <Masonry.h>

@interface BUCBaseViewController ()

@end

@implementation BUCBaseViewController {
    UIButton *_networkButton;
}

- (void)loadView {
    [super loadView];
    
    _networkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _networkButton.backgroundColor = [UIColor greenColor];
    _networkButton.layer.cornerRadius = 4;
    _networkButton.layer.masksToBounds = YES;
    _networkButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_networkButton setTitle:@"重新加载" forState:UIControlStateNormal];
    [_networkButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_networkButton addTarget:self action:@selector(didNetworkButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_networkButton];
    _networkButton.hidden = YES;
}

- (void)updateViewConstraints {
    [_networkButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 44));
    }];
    
    [super updateViewConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - Action
- (void)didNetworkButtonClick {
    [self dealNetworkError];
}

#pragma  mark - Public Methods

- (void)dealNetworkError {
    _networkButton.hidden = YES;
}




@end
