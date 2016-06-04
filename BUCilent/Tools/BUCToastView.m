//
//  BUCToastView.m
//  BUCilent
//
//  Created by dito on 16/6/4.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCToastView.h"
#import <Masonry.h>

@implementation BUCToastView {
    UIView *_backgroundView;
    UIView *_labelBackgroundView;
    UILabel *_textLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _backgroundView = [[UIView alloc] init];
    _backgroundView.backgroundColor = [UIColor clearColor];
    [self addSubview:_backgroundView];
    
    _labelBackgroundView = [[UIView alloc] init];
    _labelBackgroundView.layer.masksToBounds = YES;
    _labelBackgroundView.layer.cornerRadius = 4;
    _labelBackgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.9];
    [self addSubview:_labelBackgroundView];
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.font = [UIFont systemFontOfSize:14];
    _textLabel.textColor = [UIColor whiteColor];
    [self addSubview:_textLabel];
    
    [self updateConstraints];
}

- (void)updateConstraints {
    [_backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_labelBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset([UIScreen mainScreen].bounds.size.height / 3);
        make.centerX.equalTo(self);
    }];
    
    [_textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_labelBackgroundView).insets(UIEdgeInsetsMake(2, 6, 2, 6));
    }];
    
    [super updateConstraints];
}

- (void)setToast:(NSString *)toast {
    _toast = toast;
    if (_toast) {
        _textLabel.text = toast;
        [self updateFocusIfNeeded];
        [self setNeedsFocusUpdate];
    }
}



@end
