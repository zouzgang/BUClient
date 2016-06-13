//
//  BUCNewPostCell.m
//  BUCilent
//
//  Created by dito on 16/6/12.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCNewPostCell.h"
#import <Masonry.h>
#import "UIColor+BUC.h"
#import "BUCNewPostField.h"
#import "BUCToast.h"

@interface BUCNewPostCell () <UITextFieldDelegate>

@end

@implementation BUCNewPostCell {
    UILabel *_nameLabel;
    UITextField *_contentTextField;
}

+ (NSString *)cellReuseIdentifier {
    return @"BUCNewPostCellReuseIdentifier";
}

- (void)setupViews {
    [super setupViews];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor colorWithHexString:@"#727272"];
    _nameLabel.font = [UIFont systemFontOfSize:16];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_nameLabel];
    
    _contentTextField = [[UITextField alloc] init];
    _contentTextField.textAlignment = NSTextAlignmentRight;
    _contentTextField.font = [UIFont systemFontOfSize:14];
    _contentTextField.tintColor = [UIColor blueColor];
    _contentTextField.delegate = self;
    [_contentTextField addTarget:self action:@selector(didTextchange:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:_contentTextField];
    
    [self updateConstraints];
}

- (void)updateConstraints {
    [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(12);
        make.left.equalTo(self.contentView).offset(12);
        make.width.mas_equalTo(40);
    }];
    
    [_contentTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(30);
        make.left.equalTo(_nameLabel.mas_right).offset(12);
        make.right.equalTo(self).offset(-27);
    }];
    
    [super updateConstraints];
}

- (void)setField:(BUCNewPostField *)field {
    _field = field;
    if (_field) {
        _nameLabel.text = field.nameTitle;
        _contentTextField.placeholder = field.placeholder;
        [_contentTextField setEnabled:field.canEdit];
        _contentTextField.text = field.content;
        self.selectionStyle = field.cellSelectionStyle;
        self.accessoryType = field.cellAccessoryType;
    }
}

#pragma mark - Action
- (void)didTextchange:(UITextField *)textField {
    if (textField.text.length > 20) {
        [textField resignFirstResponder];
        [BUCToast showToast:@"字数不能大于20"];
        return;
    }
    if (textField.text) {
        if (self.inputBlock) {
            self.inputBlock(textField.text);
        }
    }
}

@end
