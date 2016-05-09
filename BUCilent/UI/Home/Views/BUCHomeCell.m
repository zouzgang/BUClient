//
//  BUCHomeCell.m
//  BUCilent
//
//  Created by dito on 16/5/8.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCHomeCell.h"
#import <Masonry.h>
#import "BUCHomeModel.h"
#import "UIColor+BUC.h"

const CGFloat kLeftPadding = 12;
const CGFloat kTopPadding = 12;

@implementation BUCHomeCell {
    UIImageView *_avatarImageView;
    UILabel *_replyLabel;
    UILabel *_titleLabel;
    UILabel *_timeLabel;
    UILabel *_contentLabel;
    
    UILabel *_forumLabel;
    UILabel *_authorLabel;
 
    UIView *_separatorLine;
}

+ (NSString *)cellReuseIdentifier {
    return @"BUCHomeCellReuseIdentifier";
}

- (void)setupViews {
    [super setupViews];
    
    _avatarImageView = [[UIImageView alloc] init];
    _avatarImageView.image = [UIImage imageNamed:@"Tabbar_MyProfile_Down"];
    [self.contentView addSubview:_avatarImageView];

    _replyLabel = [[UILabel alloc] init];
    _replyLabel.textColor = [UIColor colorWithHexString:@"#727272"];
    _replyLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_replyLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor colorWithHexString:@"#727272"];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timeLabel];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.numberOfLines = 2;
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:_titleLabel];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.textColor = [UIColor blackColor];
    _contentLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_contentLabel];
    
    _forumLabel = [[UILabel alloc] init];
    _forumLabel.textColor = [UIColor blackColor];
    _forumLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_forumLabel];
    
    _authorLabel = [[UILabel alloc] init];
    _authorLabel.textColor = [UIColor blackColor];
    _authorLabel.font = [UIFont systemFontOfSize:14];
    _authorLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_authorLabel];
    
    _separatorLine = [[UIView alloc] init];
    _separatorLine.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    [self.contentView addSubview:_separatorLine];
    
    [self updateConstraints];
}

-(void)updateConstraints {
    
    [_avatarImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kTopPadding);
        make.left.equalTo(self.contentView).offset(kLeftPadding);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [_replyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_avatarImageView.mas_centerY);
        make.left.equalTo(_avatarImageView.mas_right).offset(kLeftPadding);
    }];
    
    [_timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_replyLabel.mas_centerY);
        make.right.equalTo(self.contentView).offset(-kLeftPadding);
        make.width.mas_equalTo(120);
    }];
    
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarImageView.mas_bottom).offset(kTopPadding);
        make.left.equalTo(self.contentView).offset(kLeftPadding);
        make.right.equalTo(self.contentView).offset(-kLeftPadding);
    }];

    
    [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(kTopPadding);
        make.left.equalTo(_titleLabel.mas_left);
        make.right.equalTo(self.contentView).offset(-kLeftPadding);
    }];
    
    [_forumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentLabel.mas_bottom).offset(kTopPadding);
        make.left.equalTo(_contentLabel.mas_left);
        make.bottom.equalTo(self.contentView).offset(-kTopPadding);
    }];
    
    [_authorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_forumLabel.mas_top);
        make.right.equalTo(self.contentView).offset(-kLeftPadding);
    }];
    
    [_separatorLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kLeftPadding);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    [super updateConstraints];
}

- (void)setHomeModel:(BUCHomeModel *)homeModel {
    _homeModel = homeModel;
    if (_homeModel) {
        _titleLabel.text = [self urldecode:homeModel.pname];
        _replyLabel.text = [NSString stringWithFormat:@"%@回复了帖子", [self urldecode:homeModel.lastRelpyDict[@"who"]]];
        _timeLabel.text = [self urldecode:homeModel.lastRelpyDict[@"when"]];
        _contentLabel.text = [self urldecode:homeModel.lastRelpyDict[@"what"]];
        _forumLabel.text = [self urldecode:homeModel.fname];
        [self updateConstraints];
    }
}






@end
