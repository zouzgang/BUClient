//
//  ZZGCollectionViewCell.m
//  ZZGViewPager
//
//  Created by dito on 16/4/18.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "ZZGCollectionViewCell.h"

@implementation ZZGCollectionViewCell {
    UILabel *_titelLabel;
}

+ (NSString *)cellReuseIdentifier {
    return @"ZZGCollectionViewCellReuseIdentifier";
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor yellowColor];
    
    _titelLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 200, 50)];
    _titelLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titelLabel];
    
}

#pragma mark - Acessor
- (void)setTitle:(NSString *)title {
    _title = title;
    _titelLabel.text = title;
}


@end
