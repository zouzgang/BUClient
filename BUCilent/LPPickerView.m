//
//  LPPickerView.m
//  SocialSport
//
//  Created by zouzhigang on 15/10/27.
//  Copyright © 2015年 Loopeer. All rights reserved.
//

#import "LPPickerView.h"
#import "UIColor+BUC.h"
#import <Masonry.h>

@interface LPPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSArray *provincesNameArray;
@property (nonatomic, strong) NSArray *citysNameArray;
@property (nonatomic, copy) LPPickerViewCompletionBlock completionBlock;

@end


@implementation LPPickerView {
    UIPickerView *_myPickerView;
    UIDatePicker *_datePickerView;
    
    UIView *_separatorLine;
    UIView *_backgroundView;
    UIButton *_pickerUpConfirmButton;
    UIButton *_pickerUpCancelButton;
    
    UIView *_mongoliaVeiw;//蒙层，点击退出PicekerView
    
    NSString *_pickerViewString;
    NSDate *_date;
}

#pragma mark - UIView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaultProperty];
        [self setupViews];
    };
    return self;
}

- (void)setupDefaultProperty {
    _backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    _buttonColor = [UIColor redColor];
    _dateFormatString = @"yyyy-MM-dd";
    _datePickerMode = UIDatePickerModeDate;
    _minuteInterval = 30;
    _sexTypeNeedDefault = NO;
}

- (void)setupViews {
    
    self.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    
    _mongoliaVeiw = [[UIView alloc] init];
    _mongoliaVeiw.backgroundColor = [UIColor clearColor];
    [self addSubview:_mongoliaVeiw];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didMongoliaViewClick)];
    [_mongoliaVeiw addGestureRecognizer:tap];
    
    _backgroundView = [[UIView alloc] init];
    _backgroundView.backgroundColor = _backgroundColor;
    [self addSubview:_backgroundView];
    
    _separatorLine = [[UIView alloc] init];
    _separatorLine.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    [_backgroundView addSubview:_separatorLine];
    
    _pickerUpCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _pickerUpCancelButton.titleEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
    [_pickerUpCancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_pickerUpCancelButton setTitleColor:_buttonColor forState:UIControlStateNormal];
    [_pickerUpCancelButton addTarget:self action:@selector(didCancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:_pickerUpCancelButton];
    
    _pickerUpConfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _pickerUpConfirmButton.titleEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
    [_pickerUpConfirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [_pickerUpConfirmButton setTitleColor:_buttonColor forState:UIControlStateNormal];
    [_pickerUpConfirmButton addTarget:self action:@selector(didConfirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:_pickerUpConfirmButton];
    
    _myPickerView = [[UIPickerView alloc] init];
    _myPickerView.dataSource = self;
    _myPickerView.delegate = self;
    [_backgroundView addSubview:_myPickerView];
    
    _datePickerView = [[UIDatePicker alloc] init];
    _datePickerView.datePickerMode = _datePickerMode;
    _datePickerView.backgroundColor = self.backgroundColor;
    _datePickerView.minuteInterval = self.minuteInterval;
    [_backgroundView addSubview:_datePickerView];
    
    [self updateConstraints];
}

- (void)updateConstraints {
    
    [_pickerUpCancelButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backgroundView).offset(5);
        make.left.equalTo(_backgroundView).offset(10);
    }];
    
    [_pickerUpConfirmButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backgroundView).offset(5);
        make.right.equalTo(_backgroundView).offset(-10);
    }];
    
    [_datePickerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backgroundView.mas_left);
        make.right.equalTo(_backgroundView.mas_right);
        make.top.equalTo(_backgroundView.mas_top).offset(44);
        make.bottom.equalTo(_backgroundView.mas_bottom);
    }];
    
    [_myPickerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backgroundView.mas_left);
        make.right.equalTo(_backgroundView.mas_right);
        make.top.equalTo(_backgroundView.mas_top).offset(44);
        make.bottom.equalTo(_backgroundView.mas_bottom);
    }];
    
    [_separatorLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backgroundView.mas_top);
        make.left.equalTo(_backgroundView.mas_left).offset(12);
        make.right.equalTo(_backgroundView.mas_right).offset(-12);
        make.height.mas_equalTo(0.5);
    }];
    
    [super updateConstraints];
}

- (NSArray *)provincesNameArray {
    if (_provincesNameArray == nil) {
        _provincesNameArray = [[NSArray alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Provineces.plist" ofType:nil];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        for (NSDictionary *dictProvince in array) {
            [arrayM addObject:dictProvince];
        }
        _provincesNameArray = [arrayM copy];
    }
    return _provincesNameArray;
}

- (void)dealloc {
    NSLog(@"LPPickerView ----------- dealloc");
}

#pragma mark - Accessor

- (void)setCurrentDate:(NSDate *)currentDate {
    _currentDate = currentDate;
    _datePickerView.date = _currentDate;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    switch (self.pickerViewType) {
        case LPPickerViewTypeSex:
            return 1;
            break;
        case LPPickerViewTypeLocation:
            return 2;
            break;
        case LPPickerViewTypeTime:
            return 3;
        case LPPickerViewTypeOther:
            return 1;
            break;
        default:
            break;
    }
    return self.numberOfComponents;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (self.pickerViewType) {
        case LPPickerViewTypeSex:{
            
            return _sexTypeNeedDefault?3:2;
        }
            break;
        case LPPickerViewTypeLocation:{
            if (component == 0) {
                return self.provincesNameArray.count;
            }else {
                return self.citysNameArray.count;
            }
            
        }
            break;
        case LPPickerViewTypeTime:{
            return 2;
        }
            break;
        case LPPickerViewTypeOther:{
            return _contentArray.count;
        }
            break;
        default:
            break;
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (self.pickerViewType) {
        case LPPickerViewTypeSex:{
            if (row == 0) {
                return @"女";
            } else if(row == 1){
                return @"男";
            }else{
                return @"不限";
            }
        }
            break;
        case LPPickerViewTypeLocation:{
            if (component == 0) {
                return [self.provincesNameArray[row] objectForKey:@"ProvinceName"];
            }else {
                return self.citysNameArray[row];
            }
        }
            break;
        case LPPickerViewTypeTime:{
            return @"22";
        }
            break;
        case LPPickerViewTypeOther:{
            return _contentArray[row];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - UIPicekerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (self.pickerViewType) {
        case LPPickerViewTypeSex:{
            
        }
            break;
        case LPPickerViewTypeLocation:{
            if (component == 0) {
                NSArray *arrayTemp = [self.provincesNameArray[row] objectForKey:@"cities"];
                NSMutableArray *arrayM = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in arrayTemp) {
                    [arrayM addObject:[dict objectForKey:@"CityName"]];
                }
                self.citysNameArray = [arrayM copy];
                [pickerView reloadComponent:1];
            }
        }
            break;
        case LPPickerViewTypeOther:{
            
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - action
- (void)didCancelButtonClicked {
    [self removeSelfFromSuperViewWithAnimation];
}

- (void)didConfirmButtonClicked {
    [self removeSelfFromSuperViewWithAnimation];
    
    switch (self.pickerViewType) {
        case LPPickerViewTypeSex:{
            if ([_myPickerView selectedRowInComponent:0] == 0) {
                _pickerViewString = @"女";
            } else if([_myPickerView selectedRowInComponent:0] == 1){
                _pickerViewString = @"男";
            }else{
                _pickerViewString = @"不限";
            }
            _date = nil;
        }
            break;
        case LPPickerViewTypeLocation:{
            NSString *provinceName = [self.provincesNameArray[[_myPickerView selectedRowInComponent:0]] objectForKey:@"ProvinceName"];
            NSString *cityName = self.citysNameArray[[_myPickerView selectedRowInComponent:1]];
            if (cityName) {
                _pickerViewString = [NSString stringWithFormat:@"%@,%@",provinceName,cityName];
            } else {
                _pickerViewString = [NSString stringWithFormat:@"%@",provinceName];
            }
            _date = nil;
            
        }
            break;
        case LPPickerViewTypeTime:{
            if (_isTimeOrderBefore) {
                if ([_datePickerView.date compare:[NSDate date]] == NSOrderedDescending) {
//                    [LPToast showToast:@"请选择正确的日期"];
                    return;
                }
            }
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:self.dateFormatString];
            _pickerViewString  = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:_datePickerView.date]];
            _date = _datePickerView.date;
            
        }
            break;
        case LPPickerViewTypeOther:{
            _pickerViewString = _contentArray[[_myPickerView selectedRowInComponent:0]];
            _date = nil;    
        }
            break;
        default:
            break;
    }
    if (self.completionBlock) {
        self.completionBlock(_pickerViewString, _date);
    }
}

#pragma mark - public method

- (void)showInView:(UIView *)view animated:(BOOL)animated completionHandler:(LPPickerViewCompletionBlock) completionBlock {
    self.completionBlock = completionBlock;
    if (self.pickerViewType == LPPickerViewTypeLocation || self.pickerViewType == LPPickerViewTypeSex) {
        _datePickerView.hidden = YES;
    }else if (self.pickerViewType == LPPickerViewTypeTime) {
        _myPickerView.hidden = YES;
    }
    
    _targetView = view;
    [self layoutPickerViewInitial];
    
    [_targetView addSubview:self];
    [self layoutForVisible:!animated];
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutForVisible:YES];
        }];
    }
}

#pragma mark - private method

- (void)didMongoliaViewClick {
    [self removeSelfFromSuperViewWithAnimation];
}

- (void)removeSelfFromSuperViewWithAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutForVisible:NO];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)layoutPickerViewInitial {
    self.frame = _targetView.bounds;
}

- (void)layoutForVisible:(BOOL)visible {
    if (self.pickerViewType == LPPickerViewTypeTime) {
        _datePickerView.hidden = NO;
        if (visible) {
            self.alpha = 1;
            _mongoliaVeiw.frame = CGRectMake(0, 0,  _targetView.frame.size.width,  _targetView.frame.size.height);
            _backgroundView.frame =CGRectMake(0, _targetView.frame.size.height -200, _targetView.frame.size.width, 200);
        }else {
            self.alpha = 0;
            _mongoliaVeiw.frame = CGRectMake(0, _targetView.frame.size.height,  _targetView.frame.size.width,  _targetView.frame.size.height);
            _backgroundView.frame =CGRectMake(0, _targetView.frame.size.height, _targetView.frame.size.width, 200);
        }
    }else {
        _datePickerView.hidden = YES;
        if (visible) {
            self.alpha = 1;
            _mongoliaVeiw.frame = CGRectMake(0, 0,  _targetView.frame.size.width,  _targetView.frame.size.height);
            _backgroundView.frame =CGRectMake(0, _targetView.frame.size.height -200, _targetView.frame.size.width, 200);
        }else {
            self.alpha = 0;
            _mongoliaVeiw.frame = CGRectMake(0, _targetView.frame.size.height,  _targetView.frame.size.width,  _targetView.frame.size.height);
            _backgroundView.frame = CGRectMake(0, _targetView.frame.size.height, _targetView.frame.size.width, 200);
        }
        
    }
}

#pragma mark - Accessor
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    if (_backgroundColor) {
        _backgroundView.backgroundColor = backgroundColor;
    }else {
        _backgroundView.backgroundColor = _backgroundColor;
    }
}

- (void)setButtonColor:(UIColor *)buttonColor {
    _buttonColor = buttonColor;
    if (_buttonColor) {
        [_pickerUpCancelButton setTitleColor:_buttonColor forState:UIControlStateNormal];
        [_pickerUpConfirmButton setTitleColor:_buttonColor forState:UIControlStateNormal];
    }else {
        [_pickerUpCancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_pickerUpConfirmButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
}

- (void)setRowHeightForComponent:(CGFloat)rowHeightForComponent {
    _rowHeightForComponent = rowHeightForComponent;
    if (_rowHeightForComponent) {
        _rowHeightForComponent = rowHeightForComponent;
    } else {
        _rowHeightForComponent = 40;
    }
}

- (void)setDateFormatString:(NSString *)dateFormatString {
    _dateFormatString = dateFormatString;
    if (_dateFormatString) {
        _dateFormatString = dateFormatString;
    } else {
        _dateFormatString = @"yyyy-MM-dd";
    }
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode {
    _datePickerMode = datePickerMode;
    if (_datePickerMode) {
        _datePickerView.datePickerMode = _datePickerMode;
    }
}

- (void)setMinuteInterval:(NSInteger)minuteInterval {
    _minuteInterval = minuteInterval;
    if (_minuteInterval) {
        _datePickerView.minuteInterval = self.minuteInterval;
    }
}

- (void)setContentArray:(NSArray *)contentArray {
    _contentArray = contentArray;
}

- (void)setMinimumDate:(NSDate *)minimumDate {
    _minimumDate = minimumDate;
    if (_minimumDate) {
        _datePickerView.minimumDate = minimumDate;
    }
}

- (void)setMaximumDate:(NSDate *)maximumDate {
    _maximumDate = maximumDate;
    if (_maximumDate) {
        _datePickerView.maximumDate = maximumDate;
    }
}


@end
