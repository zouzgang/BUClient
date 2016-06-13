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
#import "BUCToast.h"
#import "CPTakePhotoTool.h"

@interface BUCReplyViewController () <UITextViewDelegate, UIScrollViewDelegate>

@end

@implementation BUCReplyViewController {
    UITextView *_textView;
    UIButton *_button;
    UIImageView *_imageView;
    UILabel *_attachLabel;
    
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
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.layer.backgroundColor = [[UIColor clearColor] CGColor];
    _textView.layer.borderColor = [[UIColor colorWithHexString:@"#F3F3F3"] CGColor];
    _textView.layer.borderWidth = 3;
    _textView.layer.cornerRadius = 8;
    _textView.layer.masksToBounds = YES;
    _textView.scrollEnabled = YES;
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
    
    _attachLabel = [[UILabel alloc] init];
    _attachLabel.textColor = [UIColor colorWithHexString:@"#727272"];
    _attachLabel.font = [UIFont systemFontOfSize:16];
    _attachLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_attachLabel];
    _attachLabel.text = @"未选择";

    _imageView = [[UIImageView alloc] init];
    [self.view addSubview:_imageView];
    _imageView.hidden = YES;
    
    [self updateViewConstraints];
}

- (void)updateViewConstraints {
    [_textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(160);
    }];
    
    [_button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textView.mas_bottom).offset(12);
        make.left.equalTo(self.view).offset(12);
        make.size.mas_equalTo(CGSizeMake(100, 44));
    }];
    
    [_attachLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_button.mas_centerY);
        make.left.equalTo(_button.mas_right).offset(12);
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

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 150) {
        [BUCToast showToast:@"字数不能大于150"];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}


#pragma mark - action
- (void)didNaviRightButtonClick {
    // reply
    [self.view endEditing:YES];
    if ((_textView.text && ![_textView.text isEqualToString:@""]) || _quoteContent) {
        self.navigationItem.rightBarButtonItem.enabled = NO;

        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        parameters[@"action"] = @"newreply";
        parameters[@"username"] = [BUCDataManager sharedInstance].username;
        parameters[@"session"] = [BUCDataManager sharedInstance].session;
        parameters[@"tid"] = [NSString stringWithFormat:@"%@", self.tid];
        NSString *message;
        if (_quoteContent) {
            message = [NSString stringWithFormat:@"%@%@",_quoteContent,_textView.text];
        } else {
            message = _textView.text;
        }
        parameters[@"message"] = message;
        parameters[@"attachment"] = _attachmentImage ? @"1" : @"0";
        
        [[BUCDataManager sharedInstance] POST:[BUCNetworkAPI requestURL:kApiNewPost] parameters:parameters attachment:_attachmentImage isForm:YES configure:nil onError:^(NSString *text) {
            NSLog(@"reply fail");
            self.navigationItem.rightBarButtonItem.enabled = YES;
        } onSuccess:^(NSDictionary *result) {
            NSLog(@"reply success");
            if (self.completBlock) {
                self.completBlock(_textView.text, _attachmentImage);
            }
            [self.navigationController popViewControllerAnimated:YES];

        }];
    } else {
        [BUCToast showToast:@"回复内容不能为空"];
    }
}

- (void)didButtonClicked {
    //add attachment
    [self.view endEditing:YES];
    [CPTakePhotoTool didClickGetPhotos:self completionBlock:^(UIImage *image) {
        NSData *data = UIImageJPEGRepresentation(image, 1);
        float length = [data length] / 1024;
        if (length > 1024) {
            [BUCToast showToast:@"附件不能大于1M"];
        } else {
            _attachmentImage = image;
            _attachLabel.text = @"已选择";
        }
    }];
}

@end
