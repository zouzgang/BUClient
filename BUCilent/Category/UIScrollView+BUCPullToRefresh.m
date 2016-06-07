//
//  UIScrollView+BUCPullToRefresh.m
//  BUCilent
//
//  Created by dito on 16/5/29.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "UIScrollView+BUCPullToRefresh.h"


static CGFloat const SVPullToRefreshViewHeight = 30;

@interface SVPullToRefreshArrow : UIView

@property (nonatomic, strong) UIColor *arrowColor;

@end


@interface BUCPullToRefreshView ()

@property (nonatomic, copy) void (^pullToRefreshActionHandler)(void);

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, readwrite) BUCPullToRefreshState state;

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, readwrite) CGFloat originalTopInset;

@property (nonatomic, assign) BOOL showsPullToRefresh;
@property(nonatomic, assign) BOOL isObserving;

- (void)resetScrollViewContentInset;
- (void)setScrollViewContentInsetForLoading;
- (void)setScrollViewContentInset:(UIEdgeInsets)insets;

@end

#pragma mark - UIScrollView (BUCPullToRefresh)
#import <objc/runtime.h>

static char UIScrollViewPullToRefreshView;

@implementation UIScrollView (BUCPullToRefresh)
@dynamic pullToRefreshView;

- (void)addPullToRefreshActionHandler:(void (^)(void))actionHandler {
    
    BUCPullToRefreshView *view = [[BUCPullToRefreshView alloc] initWithFrame:CGRectMake(0, -SVPullToRefreshViewHeight, self.bounds.size.width, SVPullToRefreshViewHeight)];
    view.pullToRefreshActionHandler = actionHandler;
    view.scrollView = self;
    [self addSubview:view];
    
    view.originalTopInset = self.contentInset.top;
    
    self.pullToRefreshView = view;
    self.showsPullToRefresh = YES;
}


- (BUCPullToRefreshView *)pullToRefreshView {
    return objc_getAssociatedObject(self, &UIScrollViewPullToRefreshView);
}

- (void)setPullToRefreshView:(BUCPullToRefreshView *)pullToRefreshView {
    [self willChangeValueForKey:@"BUCPullToRefreshView"];
    objc_setAssociatedObject(self, &UIScrollViewPullToRefreshView,
                             pullToRefreshView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"BUCPullToRefreshView"];
}

- (void)setShowsPullToRefresh:(BOOL)showsPullToRefresh {
    self.pullToRefreshView.hidden = !showsPullToRefresh;
    
    if(!showsPullToRefresh) {
        if (self.pullToRefreshView.isObserving) {
            [self removeObserver:self.pullToRefreshView forKeyPath:@"contentOffset"];
            [self removeObserver:self.pullToRefreshView forKeyPath:@"contentSize"];
            [self removeObserver:self.pullToRefreshView forKeyPath:@"frame"];
            [self.pullToRefreshView resetScrollViewContentInset];
            self.pullToRefreshView.isObserving = NO;
        }
    }
    else {
        if (!self.pullToRefreshView.isObserving) {
            [self addObserver:self.pullToRefreshView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToRefreshView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToRefreshView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
            self.pullToRefreshView.isObserving = YES;
        
            
            self.pullToRefreshView.frame = CGRectMake(0, -SVPullToRefreshViewHeight, self.bounds.size.width, SVPullToRefreshViewHeight);
        }
    }
}

- (BOOL)showsPullToRefresh {
    return !self.pullToRefreshView.hidden;
}

@end


#pragma mark - SVPullToRefresh
@implementation BUCPullToRefreshView

// public properties
@synthesize pullToRefreshActionHandler, textColor;

@synthesize state = _state;
@synthesize scrollView = _scrollView;
@synthesize showsPullToRefresh = _showsPullToRefresh;
@synthesize activityIndicatorView = _activityIndicatorView;

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        // default styling values
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.textColor = [UIColor darkGrayColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.state = BUCPullToRefreshStateStopped;
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.superview && newSuperview == nil) {
        //use self.superview, not self.scrollView. Why self.scrollView == nil here?
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if (scrollView.showsPullToRefresh) {
            if (self.isObserving) {
                //If enter this branch, it is the moment just before "SVPullToRefreshView's dealloc", so remove observer here
                [scrollView removeObserver:self forKeyPath:@"contentOffset"];
                [scrollView removeObserver:self forKeyPath:@"contentSize"];
                [scrollView removeObserver:self forKeyPath:@"frame"];
                self.isObserving = NO;
            }
        }
    }
}

- (void)layoutSubviews {
    switch (self.state) {
        case BUCPullToRefreshStateAll:
        case BUCPullToRefreshStateStopped:
            [self.activityIndicatorView stopAnimating];
            break;
            
        case BUCPullToRefreshStateTriggered:
            break;
            
        case BUCPullToRefreshStateLoading:
            [self.activityIndicatorView startAnimating];
            break;
    }
    
    CGFloat x = ([UIScreen mainScreen].bounds.size.width - 15) / 2;
    CGFloat y = (SVPullToRefreshViewHeight - 15) / 2;

    self.activityIndicatorView.frame = CGRectMake(x, y, 15, 15);
}

#pragma mark - Scroll View

- (void)resetScrollViewContentInset {
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = self.originalTopInset;
    [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInsetForLoading {
    CGFloat offset = MAX(self.scrollView.contentOffset.y * -1, 0);
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = MIN(offset, self.originalTopInset + self.bounds.size.height);
    [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.scrollView.contentInset = contentInset;
                     }
                     completion:NULL];
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"])
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    else if([keyPath isEqualToString:@"contentSize"]) {
        [self layoutSubviews];
        self.frame = CGRectMake(0, -SVPullToRefreshViewHeight, self.bounds.size.width, SVPullToRefreshViewHeight);
    }
    else if([keyPath isEqualToString:@"frame"])
        [self layoutSubviews];
    
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    if(self.state != BUCPullToRefreshStateLoading) {
        CGFloat scrollOffsetThreshold = 0;
        scrollOffsetThreshold = self.frame.origin.y - self.originalTopInset;

        if(!self.scrollView.isDragging && self.state == BUCPullToRefreshStateTriggered)
            self.state = BUCPullToRefreshStateLoading;
        else if(contentOffset.y < scrollOffsetThreshold && self.scrollView.isDragging && self.state == BUCPullToRefreshStateStopped)
            self.state = BUCPullToRefreshStateTriggered;
        else if(contentOffset.y >= scrollOffsetThreshold && self.state != BUCPullToRefreshStateStopped)
            self.state = BUCPullToRefreshStateStopped;
        else if(contentOffset.y > scrollOffsetThreshold && self.scrollView.isDragging && self.state == BUCPullToRefreshStateStopped)
            self.state = BUCPullToRefreshStateTriggered;
        else if(contentOffset.y <= scrollOffsetThreshold && self.state != BUCPullToRefreshStateStopped)
            self.state = BUCPullToRefreshStateStopped;
    } else {
        CGFloat offset;
        UIEdgeInsets contentInset;
        offset = MAX(self.scrollView.contentOffset.y * -1, 0.0f);
        offset = MIN(offset, self.originalTopInset + self.bounds.size.height);
        contentInset = self.scrollView.contentInset;
        self.scrollView.contentInset = UIEdgeInsetsMake(offset, contentInset.left, contentInset.bottom, contentInset.right);
    }
}

#pragma mark - Getters

- (UIActivityIndicatorView *)activityIndicatorView {
    if(!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicatorView.hidesWhenStopped = YES;
        [self addSubview:_activityIndicatorView];
    }
    return _activityIndicatorView;
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 210, 20)];
        _titleLabel.text = NSLocalizedString(@"Pull to refresh...",);
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = textColor;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}


- (UIColor *)textColor {
    return self.titleLabel.textColor;
}

- (UIColor *)activityIndicatorViewColor {
    return self.activityIndicatorView.color;
}

- (UIActivityIndicatorViewStyle)activityIndicatorViewStyle {
    return self.activityIndicatorView.activityIndicatorViewStyle;
}

#pragma mark - Setters

- (void)setActivityIndicatorViewColor:(UIColor *)color {
    self.activityIndicatorView.color = color;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)viewStyle {
    self.activityIndicatorView.activityIndicatorViewStyle = viewStyle;
}

#pragma mark -
- (void)startAnimating{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -self.frame.size.height) animated:YES];
    self.state = BUCPullToRefreshStateLoading;
}

- (void)stopAnimating {
    self.state = BUCPullToRefreshStateStopped;
    
     [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -self.originalTopInset) animated:YES];
}

- (void)setState:(BUCPullToRefreshState)newState {
    
    if(_state == newState)
        return;
    
    BUCPullToRefreshState previousState = _state;
    _state = newState;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    switch (newState) {
        case BUCPullToRefreshStateAll:
        case BUCPullToRefreshStateStopped:
            [self resetScrollViewContentInset];
            break;
            
        case BUCPullToRefreshStateTriggered:
            break;
            
        case BUCPullToRefreshStateLoading:
            [self setScrollViewContentInsetForLoading];
            
            if(previousState == BUCPullToRefreshStateTriggered && pullToRefreshActionHandler)
                pullToRefreshActionHandler();
            
            break;
    }
}


@end
