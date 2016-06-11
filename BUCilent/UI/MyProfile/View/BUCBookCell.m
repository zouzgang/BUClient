//
//  BUCBookCell.m
//  BUCilent
//
//  Created by dito on 16/6/11.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCBookCell.h"
#import <Masonry.h>
#import "UIColor+BUC.h"
#import "BUCSearchModel.h"
#import "BUCBookModel.h"


@implementation BUCBookCell {
    UILabel *_titleLabel;
    UILabel *_authorLabel;
    UILabel *_timeLabel;
    UIView *_separatorLine;
}

+ (NSString *)cellReuseIdentifier {
    return @"BUCBookCellReuseIdentifier";
}

- (void)setupViews {
    [super setupViews];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.numberOfLines = 2;
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:_titleLabel];
    
    _authorLabel = [[UILabel alloc] init];
    _authorLabel.textColor = [UIColor blackColor];
    _authorLabel.font = [UIFont systemFontOfSize:14];
    _authorLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_authorLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor colorWithHexString:@"#727272"];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timeLabel];
    
    _separatorLine = [[UIView alloc] init];
    _separatorLine.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    [self.contentView addSubview:_separatorLine];
    
    [self updateConstraints];
}

- (void)updateConstraints {
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(12);
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
    }];
    
    [_authorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(12);
        make.left.equalTo(self.contentView).offset(12);
        make.bottom.equalTo(self.contentView).offset(-12);
    }];
    
    [_timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_authorLabel.mas_centerY);
        make.right.equalTo(self.contentView).offset(-12);
        make.width.mas_equalTo(120);
    }];
    
    [_separatorLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];

    [super updateConstraints];
}

- (void)setSearchModel:(BUCSearchModel *)searchModel {
    _searchModel = searchModel;
    if (_searchModel) {
        _titleLabel.text = [self urldecode:searchModel.postTitle];
        _authorLabel.text = [self urldecode:searchModel.author];
        [self updateConstraints];

    }
}

- (void)setBookModel:(BUCBookModel *)bookModel {
    _bookModel = bookModel;
    if (_bookModel) {
        _titleLabel.text = [self urldecode:bookModel.postTitle];
        _authorLabel.text = [self urldecode:bookModel.author];
        [self updateConstraints];
    }
}

@end
