//
//  BUCReplyViewController.m
//  BUCilent
//
//  Created by dito on 16/5/10.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCReplyViewController.h"
#import <Masonry.h>
#import "BUCDataManager.h"
#import "BUCNetworkAPI.h"
#import "UIColor+BUC.h"

@implementation BUCReplyViewController {
    UITextView *_textView;
    UIButton *_button;
    UIImageView *_imageView;
    
    UIImage *_attachmentImage;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    _textView = [[UITextView alloc] init];
    _textView.layer.backgroundColor = [[UIColor clearColor] CGColor];
    _textView.layer.borderColor = [[UIColor colorWithHexString:@"#F3F3F3"] CGColor];
    _textView.layer.borderWidth = 3;
    _textView.layer.cornerRadius = 8;
    _textView.layer.masksToBounds = YES;
    [self.view addSubview:_textView];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.layer.borderColor =  [[UIColor colorWithHexString:@"#F3F3F3"] CGColor];
    _button.layer.borderWidth = 3;
    _button.layer.cornerRadius = 8;
    _button.layer.masksToBounds = YES;
    [_button setTitle:@"添加附件" forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont systemFontOfSize:14];
    [_button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(didButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];

    _imageView = [[UIImageView alloc] init];
    [self.view addSubview:_imageView];
    _imageView.hidden = YES;
    
    [self updateViewConstraints];
}

- (void)updateViewConstraints {
    [_textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(200);
    }];
    
    [_button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textView.mas_bottom).offset(12);
        make.left.equalTo(self.view).offset(12);
        make.size.mas_equalTo(CGSizeMake(100, 44));
    }];
    
    [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(_textView.mas_bottom).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [super updateViewConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didNaviRightButtonClick)];
}


#pragma mark - action
- (void)didNaviRightButtonClick {
    // reply
    if (_textView.text && ![_textView.text isEqualToString:@""]) {
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        parameters[@"action"] = @"newreply";
        parameters[@"username"] = [BUCDataManager sharedInstance].username;
        parameters[@"session"] = [BUCDataManager sharedInstance].session;
        parameters[@"tid"] = self.tid;
        
        parameters[@"message"] = _textView.text;
        parameters[@"attachment"] = _attachmentImage ? @"1" : @"0";
        
        [[BUCDataManager sharedInstance] POST:[BUCNetworkAPI requestURL:kApiNewPost] parameters:parameters attachment:_attachmentImage isForm:YES onError:^(NSString *text) {
            NSLog(@"reply fail");
        } onSuccess:^(NSDictionary *result) {
            NSLog(@"reply success");
            if (self.completBlock) {
                self.completBlock(_textView.text, _attachmentImage);
            }
            [self.navigationController popViewControllerAnimated:YES];

        }];
    }
}

- (void)didButtonClicked {
    //add attachment
}

@end
