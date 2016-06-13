//
//  BUCNewPostViewController.m
//  BUCilent
//
//  Created by dito on 16/6/10.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCNewPostViewController.h"
#import "BUCNewPostCell.h"
#import <Masonry.h>
#import "BUCNewPostField.h"
#import "UIColor+BUC.h"
#import "LPPickerView.h"
#import "BUCNewPostField.h"
#import "BUCDataManager.h"
#import "BUCToast.h"
#import "NSString+Tools.h"
#import "BUCNetworkAPI.h"
#import "CPTakePhotoTool.h"
#import "BUCStringTool.h"


@interface BUCNewPostViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@end

@implementation BUCNewPostViewController {
    UITableView *_tableView;
    UITextView *_textView;
    
    UIScrollView *_scrollView;
    
    NSArray<BUCNewPostField *> *_dataArray;
    NSMutableDictionary *_forumDict;
    UIImage *_attachmentImage;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNilni {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNilni];
    if (self) {
        self.navigationItem.title = @"发帖子";
        _forumDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 64);
    [self.view addSubview:_scrollView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 44;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 0);
    _tableView.scrollEnabled = NO;
    [_tableView registerClass:[BUCNewPostCell class] forCellReuseIdentifier:[BUCNewPostCell cellReuseIdentifier]];
    [_scrollView addSubview:_tableView];
    
    _textView = [[UITextView alloc] init];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.layer.backgroundColor = [[UIColor clearColor] CGColor];
    _textView.layer.borderColor = [[UIColor colorWithHexString:@"#F3F3F3"] CGColor];
    _textView.layer.borderWidth = 3;
    _textView.layer.cornerRadius = 8;
    _textView.layer.masksToBounds = YES;
    _textView.scrollEnabled = YES;
    [_scrollView addSubview:_textView];
    
    [self updateViewConstraints];
}

- (void)updateViewConstraints {
    [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView.mas_top);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44 * 3);
    }];
    
    [_textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(self.view.frame.size.height - 44 * 3);
    }];
    
    
    [super updateViewConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(didSubmitButtonClick)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(didCancelButtonClick)];
    
    [self loadData];
}

- (void)loadData {
    _dataArray = [BUCNewPostField fieldList];
    

    NSString *path = [[NSBundle mainBundle] pathForResource:@"BUCForumList.plist" ofType:nil];
    NSArray *array = [NSMutableArray arrayWithContentsOfFile:path];
    [_forumDict setObject:@"177" forKey:@"测试专用子版"];
    for (NSDictionary *dic in array) {
        NSArray *arrayInner = dic[@"list"];
        for (NSDictionary *dicInner in arrayInner) {
            [_forumDict setObject:dicInner[@"fid"] forKey:dicInner[@"name"]];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BUCNewPostCell *cell = [tableView dequeueReusableCellWithIdentifier:[BUCNewPostCell cellReuseIdentifier] forIndexPath:indexPath];
    cell.field = _dataArray[indexPath.row];
    if (indexPath.row == 1) {
        cell.inputBlock = ^(NSString *text) {
            _dataArray[indexPath.row].content = text;
        };
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];

    if (indexPath.row == 0) {
        LPPickerView *picker = [[LPPickerView alloc] init];
        picker.pickerViewType = LPPickerViewTypeOther;
        picker.contentArray = _forumDict.allKeys;
        [picker showInView:self.view animated:YES completionHandler:^(NSString *text, NSDate *date) {
            _dataArray[indexPath.row].content = text;
            [_tableView reloadData];
            NSLog(@"%@", text);
        }];
    } else if (indexPath.row == 2) {
        [CPTakePhotoTool didClickGetPhotos:self completionBlock:^(UIImage *image) {
            NSData *data = UIImageJPEGRepresentation(image, 1);
            float length = [data length] / 1024;
            if (length > 1024) {
                [BUCToast showToast:@"附件不能大于1M"];
            } else {
                _attachmentImage = image;
                _dataArray[indexPath.row].content = @"已选择附件";
                [_tableView reloadData];
            }
        }];
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [UIView animateWithDuration:0.4 animations:^{
        _scrollView.contentOffset = CGPointMake(0, 44 * 2);
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [UIView animateWithDuration:0.4 animations:^{
        [_scrollView scrollsToTop];
        _scrollView.contentOffset = CGPointMake(0, 0);
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 150) {
        [textView resignFirstResponder];
        [BUCToast showToast:@"字数不能大于150"];
    }
}

#pragma mark - Action
- (void)didSubmitButtonClick {
    
    if ([NSString isEmptyString:_dataArray[0].content]) {
        [BUCToast showToast:@"板块不能为空"];
        return;
    }
    if ([NSString isEmptyString:_dataArray[1].content]) {
        [BUCToast showToast:@"标题不能为空"];
        return;
    }
    
    if ([NSString isEmptyString:_textView.text]) {
        [BUCToast showToast:@"内容不能为空"];
        return;
    }
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"action"] = @"newthread";
    parameters[@"username"] = [BUCDataManager sharedInstance].username;
    parameters[@"session"] = [BUCDataManager sharedInstance].session;
    parameters[@"fid"] = _forumDict[_dataArray[0].content];
    parameters[@"subject"] = _dataArray[1].content;
    parameters[@"message"] = _textView.text;
    parameters[@"attachment"] = _attachmentImage ? @"1" : @"0";
    
    [[BUCDataManager sharedInstance] POST:[BUCNetworkAPI requestURL:kApiNewPost] parameters:parameters attachment:_attachmentImage isForm:YES configure:nil onError:^(NSString *text) {
        NSLog(@"new thread fail");
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } onSuccess:^(NSDictionary *result) {
        NSLog(@"new thread success");
        [BUCToast showToast:@"已发表"];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    
}

- (void)didCancelButtonClick {
    [self.view endEditing:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
