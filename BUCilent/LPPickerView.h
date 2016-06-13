//
//  LPPickerView.h
//  SocialSport
//
//  Created by zouzhigang on 15/10/27.
//  Copyright © 2015年 Loopeer. All rights reserved.
//
/**
 *pickerView
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LPPickerViewType) {
    LPPickerViewTypeSex,/**<性别*/
    LPPickerViewTypeLocation,/**<地点*/
    LPPickerViewTypeTime,/**<日期*/
    LPPickerViewTypeOther/**<其他*/
};

//typedef NS_ENUM(NSInteger, LPDatePickerMode) {
//    LPDatePickerModeTime,           // Displays hour, minute, and optionally AM/PM designation depending on the locale setting (e.g. 6 | 53 | PM)
//    LPDatePickerModeDate,           // Displays month, day, and year depending on the locale setting (e.g. November | 15 | 2007)
//    LPDatePickerModeDateAndTime,    // Displays date, hour, minute, and optionally AM/PM designation depending on the locale setting (e.g. Wed Nov 15 | 6 | 53 | PM)
//    LPDatePickerModeCountDownTimer, // Displays hour and minute (e.g. 1 | 53)
//} __TVOS_PROHIBITED;

typedef void(^LPPickerViewCompletionBlock)(NSString *text, NSDate *date);

@interface LPPickerView : UIView

@property (nonatomic, assign) LPPickerViewType pickerViewType;

@property (nonatomic, copy) NSString *dateFormatString;/**<dateFormat格式,默认"yyyy-MM-dd";*/
@property (nonatomic) UIDatePickerMode datePickerMode;/**<UIDatePickerMode，默认UIDatePickerModeDate*/
@property (nonatomic,assign) NSInteger  minuteInterval;/**<显示时间间隔，默认30*/
@property (nonatomic, strong) NSDate *minimumDate; /**<picker能选择的最小日期*/
@property (nonatomic, strong) NSDate *maximumDate; /**<picker能选择的最大日期*/
@property (nonatomic, strong) NSDate *currentDate; /**<picker默认选中日期*/
@property (nonatomic, assign) BOOL isTimeOrderBefore;/**<时间顺序*/

@property (nonatomic, strong) UIColor *backgroundColor;/**<picker的背景颜色，默认[UIColor btk_backgroundColor]*/
@property (nonatomic, strong) UIColor *buttonColor;/**<确定取消按钮的颜色，默认[UIColor redColor]*/

@property (nonatomic, weak, readonly) UIView *targetView;/**<用来保存该Piceker显示的super view*/

@property (nonatomic, assign) NSUInteger numberOfComponents;/**<最多选项数,默认不限制*/
@property (nonatomic, assign) NSUInteger numberOfRowsInComponents;/**<最多选项数,默认不限制*/
@property (nonatomic, assign) CGFloat rowHeightForComponent;/**<行高*/
//Sex选择器是否需要有默认值(默认内容为不限),默认为NO
@property (assign ,nonatomic)BOOL sexTypeNeedDefault;

@property (nonatomic, strong) NSArray *contentArray;/**<picker为其他类型时，传入的数据源数组*/

- (void)showInView:(UIView *)view animated:(BOOL)animated completionHandler:(LPPickerViewCompletionBlock) completionBlock;

@end
