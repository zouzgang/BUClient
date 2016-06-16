//
//  BUCBaseTableViewCell.m
//  BUCilent
//
//  Created by dito on 16/5/8.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCBaseTableViewCell.h"

@implementation BUCBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.opaque = YES;
}


+ (NSString *)cellReuseIdentifier {
    return NSStringFromClass([self class]);
}

- (void)refreshConstraints {
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (NSString *)urlencode:(NSString *)string {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[string UTF8String];
    int i = 0;
    unsigned char thisChar = source[i];
    while (thisChar != '\0') {
        if (thisChar == ' ') {
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
        i = i + 1;
        thisChar = source[i];
    }
    
    return output;
}

- (NSString *)urldecode:(NSString *)string {
    if (!string || (id)string == [NSNull null] || string.length == 0) {
        return nil;
    }
    
    static const unsigned char hexValue['f' - '0' + 1] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0,0,0,0,0,0,0, 10, 11, 12, 13, 14, 15};
    const unsigned char *source = (const unsigned char *)[string UTF8String];
    NSUInteger length = [string maximumLengthOfBytesUsingEncoding: NSUTF8StringEncoding];
    unsigned char output[length];
    int indexOutput = 0;
    int indexSource = 0;
    unsigned char thisChar = source[indexSource];
    while (thisChar != '\0') {
        if (thisChar == '+') {
            output[indexOutput] = ' ';
        } else if (thisChar == '%') {
            output[indexOutput] = (hexValue[source[indexSource + 1] - '0'] << 4) + hexValue[source[indexSource + 2] - '0'];
            indexSource = indexSource + 2;
        } else {
            output[indexOutput] = thisChar;
        }
        indexOutput = indexOutput + 1;
        indexSource = indexSource + 1;
        thisChar = source[indexSource];
    }
    output[indexOutput] = '\0';
    
    return [NSString stringWithUTF8String:(const char *)output];
}

///////分析日期
- (NSString *)parseDateline:(NSString *)dateline {
    if (!dateline || (id)dateline == [NSNull null] || dateline.length == 0) {
        return nil;
    }
    
    static NSDateFormatter *dateFormatter;
    static NSDateFormatter *parsingFormatter;
    static NSRegularExpression *regex;
    static dispatch_once_t onceEnsure;
    dispatch_once(&onceEnsure, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_Hans_CN"];
        parsingFormatter = [[NSDateFormatter alloc] init];
        [parsingFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        regex = [NSRegularExpression regularExpressionWithPattern:@"^[0-9]+$" options:NSRegularExpressionCaseInsensitive error:NULL];
    });
    
    NSString *output;
    NSDate *date;
    
    if ([regex numberOfMatchesInString:dateline options:0 range:NSMakeRange(0, dateline.length)] == 0) {
        date = [parsingFormatter dateFromString:dateline];
    } else {
        date = [NSDate dateWithTimeIntervalSince1970:dateline.doubleValue];
    }
    
    NSTimeInterval timeInterval = abs(date.timeIntervalSinceNow);
    if (timeInterval < 60) {
        output = @"刚刚";
    } else if (timeInterval < 60 * 60) {
        output = [NSString stringWithFormat:@"%d 分钟前", (int)timeInterval / 60];
    } else if (timeInterval < 60 * 60 * 24) {
        output = [NSString stringWithFormat:@"%d 小时前", (int)timeInterval / (60 * 60)];
    } else if (timeInterval < 60 * 60 * 24 * 30) {
        output = [NSString stringWithFormat:@"%d 天前", (int)timeInterval / (60 * 60 * 24)];
    } else if (timeInterval < 60 * 60 * 24 * 30 * 12) {
        output = [NSString stringWithFormat:@"%d 个月前", (int)timeInterval / (60 * 60 * 24 * 30)];
    } else {
        output = [dateFormatter stringFromDate:date];
    }
    
    
    return output;
}

- (NSString *)parseDatelineToStandard:(NSString *)dateline {
    if (!dateline || (id)dateline == [NSNull null] || dateline.length == 0) {
        return nil;
    }
    
    static NSDateFormatter *dateFormatter;
    static NSDateFormatter *parsingFormatter;
    static NSRegularExpression *regex;
    static dispatch_once_t onceEnsure;
    dispatch_once(&onceEnsure, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_Hans_CN"];
        parsingFormatter = [[NSDateFormatter alloc] init];
        [parsingFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        regex = [NSRegularExpression regularExpressionWithPattern:@"^[0-9]+$" options:NSRegularExpressionCaseInsensitive error:NULL];
    });
    
    NSString *output;
    NSDate *date;
    
    if ([regex numberOfMatchesInString:dateline options:0 range:NSMakeRange(0, dateline.length)] == 0) {
        date = [parsingFormatter dateFromString:dateline];
    } else {
        date = [NSDate dateWithTimeIntervalSince1970:dateline.doubleValue];
    }
    
    output = [dateFormatter stringFromDate:date];

    
    
    return output;
}



@end
