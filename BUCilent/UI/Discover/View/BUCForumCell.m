//
//  BUCForumCell.m
//  BUCilent
//
//  Created by dito on 16/5/29.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCForumCell.h"
#import "BUCForumModel.h"
#import <Masonry.h>
#import "UIColor+BUC.h"

const CGFloat kForumCellLeftPadding = 12;
const CGFloat kForumCellTopPadding = 12;


@implementation BUCForumCell {
    UILabel *_titleLabel;
    UILabel *_authorLabel;
    UILabel *_scanCountLabel;
    UILabel *_dateLabel;
    
    UIView *_separatorLine;
}

+ (NSString *)cellReuseIdentifier {
    return @"BUCForumCellReuseIdentifier";
}

- (void)setupViews {
    [super setupViews];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.numberOfLines = 2;
    _titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_titleLabel];
    
    _authorLabel = [[UILabel alloc] init];
    _authorLabel.textColor = [UIColor colorWithHexString:@"#727272"];
    _authorLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_authorLabel];
    
    _scanCountLabel = [[UILabel alloc] init];
    _scanCountLabel.textColor = [UIColor colorWithHexString:@"#727272"];
    _scanCountLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_scanCountLabel];
    
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.textColor = [UIColor colorWithHexString:@"#727272"];
    _dateLabel.font = [UIFont systemFontOfSize:15];
    _dateLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_dateLabel];
    
    _separatorLine = [[UIView alloc] init];
    _separatorLine.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    [self.contentView addSubview:_separatorLine];
    
     [self updateConstraints];
}

- (void)updateConstraints {
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kForumCellTopPadding);
        make.left.equalTo(self.contentView).offset(kForumCellLeftPadding);
        make.right.equalTo(self.contentView).offset(-kForumCellLeftPadding);
    }];
    
    [_authorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(kForumCellTopPadding);
        make.left.equalTo(_titleLabel.mas_left);
        make.width.mas_equalTo(120);
        make.bottom.equalTo(self.contentView).offset(- kForumCellTopPadding);
    }];
    
    [_scanCountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_authorLabel.mas_top);
        make.left.equalTo(_authorLabel.mas_right).offset(2 * kForumCellLeftPadding);
        make.width.mas_equalTo(80);
    }];
    
    [_dateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_authorLabel.mas_top);
        make.right.equalTo(self.contentView).offset(-kForumCellLeftPadding);
        make.left.equalTo(_scanCountLabel.mas_right).offset(kForumCellLeftPadding);
    }];
    
    [_separatorLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kForumCellLeftPadding);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    [super updateConstraints];
}

- (void)setForumModel:(BUCForumModel *)forumModel {
    _forumModel = forumModel;
    
    if (_forumModel) {
        _titleLabel.text = [self urldecode:_forumModel.subject];
        _authorLabel.text = [self urldecode:_forumModel.author];
        _scanCountLabel.text = [NSString stringWithFormat:@"%@/%@", _forumModel.replies, _forumModel.views];
        _dateLabel.text = [self parseDateline:_forumModel.dateline];
        [super refreshConstraints];
    }
    
}

@end
