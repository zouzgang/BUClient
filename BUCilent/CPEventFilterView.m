//
//  CPEventFilterView.m
//  confPlus
//
//  Created by dito on 16/5/23.
//  Copyright © 2016年 Loopeer. All rights reserved.
//

#import "CPEventFilterView.h"

typedef void(^CPEventFilterViewCompletehandler)(NSInteger index);

NSInteger const kFilterViewButtonTag= 203;
@interface CPEventFilterView ()

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UIView *targetView;
@property (nonatomic, copy) CPEventFilterViewCompletehandler completehandler;


@end

@implementation CPEventFilterView {
 
    UIView *_backgroundView;
}

- (void)showInView:(UIView *)view titles:(NSArray *)titles completehandler:(void(^)(NSInteger index))completehandler {
    self.targetView = view;
    self.titles = titles;
    self.completehandler = completehandler;
    
    [view addSubview:self];
    self.frame = CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height);
    
    _backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0] ;
    _backgroundView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    [UIView animateWithDuration:0.25 animations:^{
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        _backgroundView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    }];
    
    [self initButton];
}

- (void)initButton {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_targetView.bounds.size.width * 2 / 3, -6, _targetView.bounds.size.width / 3 - 4, _titles.count * 44 + 6)];
    UIImage *image = [UIImage imageNamed:@"event_filter_view"];
    imageView.image = image;

    imageView.alpha = 1;
    [_backgroundView addSubview:imageView];
    
    for (NSInteger i = 0; i < _titles.count; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_targetView.bounds.size.width * 2 / 3, i * 44 + 6, _targetView.bounds.size.width / 3, 44)];
        button.tag = i + kFilterViewButtonTag;
        button.opaque = YES;
        button.titleLabel.backgroundColor = [UIColor whiteColor];
        [button setTitle:_titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(didButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundView addSubview:button];
    }
    
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
    _backgroundView.userInteractionEnabled = YES;
    _backgroundView.backgroundColor = [UIColor blackColor];
    [self addSubview:_backgroundView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didBackgroundViewTap)];
    [self addGestureRecognizer:tap];
}

#pragma mark - Action
- (void)didButtonClicked:(UIButton *)button {
    if (self.completehandler) {
        self.completehandler(button.tag - kFilterViewButtonTag);
    }
   
    [self removeSelf];
}

- (void)didBackgroundViewTap {
    if (self.completehandler) {
        self.completehandler(-1);
    }
    [self removeSelf];
}

#pragma mark - Private
-(void)removeSelf {
    [UIView animateWithDuration:0.25 animations:^{
        [self removeFromSuperview];
    }];
}

@end
