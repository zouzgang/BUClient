//
//  BUCNewPostViewController.m
//  BUCilent
//
//  Created by dito on 16/6/10.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCNewPostViewController.h"

@interface BUCNewPostViewController ()

@end

@implementation BUCNewPostViewController {
    
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNilni {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNilni];
    if (self) {
        self.title = @"发帖子";
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(didSubmitButtonClick)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(didCancelButtonClick)];
}


#pragma mark - Action
- (void)didSubmitButtonClick {
}

- (void)didCancelButtonClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
