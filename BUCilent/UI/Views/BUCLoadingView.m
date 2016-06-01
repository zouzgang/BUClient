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
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.hidden = YES;
    
    _backgroudView = [[UIView alloc] init];
    _backgroudView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8];
    _backgroudView.layer.cornerRadius = 4;
    _backgroudView.layer.masksToBounds = YES;
    [self addSubview:_backgroudView];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [_backgroudView addSubview:_indicatorView];
}

- (void)updateConstraints {
    [_backgroudView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    [_indicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_backgroudView.mas_centerY);
        make.centerX.equalTo(_backgroudView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(60, 60));
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




@end
