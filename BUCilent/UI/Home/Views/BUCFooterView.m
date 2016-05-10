//
//  BUCFooterView.m
//  BUCilent
//
//  Created by dito on 16/5/10.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCFooterView.h"
#import <Masonry.h>

@implementation BUCFooterView {
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
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_nameLabel];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:_indicatorView];
    
}

- (void)updateConstraints {
    
    [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [_indicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
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

- (void)showText {
    self.hidden = NO;
    _indicatorView.hidden = YES;
    _nameLabel.text = @"没有更多了";
}



@end
