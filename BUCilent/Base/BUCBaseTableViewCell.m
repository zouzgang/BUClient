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


@end
