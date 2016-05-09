//
//  BUCLoadingView.m
//  BUCilent
//
//  Created by dito on 16/5/9.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCLoadingView.h"
#import <Masonry.h>

@implementation BUCLoadingView {
    UIView *_backgroudView;
    UILabel *_nameLabel;
    UIActivityIndicatorView *_indicatorView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefault];
        [self setupViews];
    }
    return self;
}

- (void)setupDefault {
    _loadingText = @"加载中......";
}

- (void)setupViews {
    self.hidden = YES;
    
    _backgroudView = [[UIView alloc] init];
    _backgroudView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backgroudView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = _loadingText;
    [_backgroudView addSubview:_nameLabel];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [_backgroudView addSubview:_indicatorView];
    
}

- (void)updateConstraints {
    [_backgroudView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.center.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backgroudView.mas_top);
        make.left.equalTo(_backgroudView.mas_left);
        make.bottom.equalTo(_backgroudView.mas_bottom);
    }];
    
    [_indicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_backgroudView.mas_centerY);
        make.left.mas_equalTo(_nameLabel.mas_right).offset(8);
        make.right.equalTo(_backgroudView.mas_right);
    }];
    
    [super updateConstraints];
}

#pragma mark - Public Methods
- (void)startAnimation {
    self.hidden = NO;
    [_indicatorView startAnimating];
}

- (void)stopAnimation {
    [_indicatorView stopAnimating];
    self.hidden = YES;
}


#pragma mark - Accessor
- (void)setLoadingText:(NSString *)loadingText {
    _loadingText = loadingText;
    if (_loadingText) {
        _nameLabel.text = _loadingText;
        [self updateConstraints];
    }
}



@end
