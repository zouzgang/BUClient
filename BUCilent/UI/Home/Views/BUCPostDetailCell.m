//
//  BUCPostDetailCell.m
//  BUCilent
//
//  Created by dito on 16/5/9.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCPostDetailCell.h"
#import "BUCPostDetailModel.h"
#import "BUCHtmlScraper.h"
#import <Masonry.h>
#import "UIColor+BUC.h"
#import "UITableView+FDTemplateLayoutCell.h"

const CGFloat kDetailCellLeftPadding = 12;
const CGFloat kDetailCellTopPadding = 12;

@implementation BUCPostDetailCell {
    UIImageView *_avatarImageView;
    UILabel *_authorLabel;
    UILabel *_timeLabel;
    UILabel *_countLabel;
    UILabel *_contentLabel;
    UIButton *_replyButton;
    UIView *_separatorLine;
    UIView *_separatorLineTop;
    
    NSAttributedString *_atttibutedString;
}

+ (NSString *)cellReuseIdentifier {
    return @"BUCPostDetailCellReuseIdentifier";
}

- (void)setupViews {
    [super setupViews];
    self.fd_enforceFrameLayout = YES;
    
    _avatarImageView = [[UIImageView alloc] init];
    _avatarImageView.image = [UIImage imageNamed:@"Tabbar_MyProfile_Down"];
    [self.contentView addSubview:_avatarImageView];

    _authorLabel = [[UILabel alloc] init];
    _authorLabel.textColor = [UIColor blackColor];
    _authorLabel.font = [UIFont systemFontOfSize:13];
    _authorLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_authorLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor blackColor];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timeLabel];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.textColor = [UIColor blackColor];
    _countLabel.font = [UIFont systemFontOfSize:13];
    _countLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_countLabel];
    
    _separatorLineTop = [[UIView alloc] init];
    _separatorLineTop.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    [self.contentView addSubview:_separatorLineTop];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.numberOfLines = 0;
    [self.contentView addSubview:_contentLabel];
    
    _replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_replyButton setTitle:@"回复" forState:UIControlStateNormal];
    _replyButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_replyButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_replyButton addTarget:self action:@selector(didReplyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_replyButton];
    
    _separatorLine = [[UIView alloc] init];
    _separatorLine.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    [self.contentView addSubview:_separatorLine];
    
    [self updateConstraints];

}

- (void)updateConstraints {
    [_avatarImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kDetailCellTopPadding);
        make.left.equalTo(self.contentView).offset(kDetailCellLeftPadding);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [_authorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarImageView.mas_top);
        make.left.equalTo(_avatarImageView.mas_right).offset(kDetailCellLeftPadding);
    }];
    
    [_timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_authorLabel.mas_bottom).offset(kDetailCellTopPadding);
        make.left.equalTo(_avatarImageView.mas_right).offset(kDetailCellLeftPadding);
    }];
    
    [_countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kDetailCellTopPadding);
        make.right.equalTo(self.contentView).offset(-kDetailCellLeftPadding);
        make.width.mas_equalTo(100);
    }];
    
    [_separatorLineTop mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_avatarImageView.mas_bottom).offset(kDetailCellLeftPadding / 2);
        make.left.equalTo(_avatarImageView.mas_left);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarImageView.mas_bottom).offset(kDetailCellTopPadding);
        make.left.equalTo(self.contentView).offset(kDetailCellLeftPadding);
        make.right.equalTo(self.contentView).offset(-kDetailCellLeftPadding);
        make.bottom.equalTo(self.contentView).offset(-2 * kDetailCellTopPadding);
    }];
    
    [_replyButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-kDetailCellLeftPadding);
        make.bottom.equalTo(self.contentView).offset(-kDetailCellTopPadding / 2);
    }];
    
    [_separatorLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kDetailCellLeftPadding);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    [super updateConstraints];
}
//
//- (CGFloat)height:(BUCPostDetailModel *)model {
//    [self layoutIfNeeded];
//    CGFloat height = kDetailCellTopPadding + 50 + kDetailCellTopPadding + [self heightOfContent].height + kDetailCellTopPadding * 3;
//
//    return height;
//}

- (CGSize)sizeThatFits:(CGSize)size {
    [self layoutIfNeeded];
    CGFloat height = kDetailCellTopPadding + 50 + kDetailCellTopPadding + [self heightOfContent].height + kDetailCellTopPadding * 2;
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, height);
}

- (CGSize)heightOfContent {
    NSTextStorage *textStorage = [[NSTextStorage alloc]init];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc]init];
    [textStorage addLayoutManager:layoutManager];
    
    NSTextContainer *textContainer = [[NSTextContainer alloc]initWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * kDetailCellLeftPadding, MAXFLOAT)];
    [textContainer setLineFragmentPadding:5.0];
    [layoutManager addTextContainer:textContainer];
    
    [textStorage setAttributedString:_atttibutedString];
    [layoutManager glyphRangeForTextContainer:textContainer];
    [layoutManager ensureLayoutForTextContainer:textContainer];
    
    CGRect frame = [layoutManager usedRectForTextContainer:textContainer];
    return CGSizeMake(frame.size.width, frame.size.height);
}

- (void)setPostDetailModel:(BUCPostDetailModel *)postDetailModel {
    _postDetailModel = postDetailModel;
    
    NSMutableString *content = [[NSMutableString alloc] init];
    NSString *title = [self urldecode:_postDetailModel.subject];
    if (title) {
        title = [NSString stringWithFormat:@"<b>%@</b>\n\n", title];
        [content appendString:title];
    }
    //////message
    NSString *body = [self urldecode:_postDetailModel.message];
    if (body != nil) {
        [content appendString:body];
    }
    
    _atttibutedString = [[NSMutableAttributedString alloc] init];
    _atttibutedString = [[BUCHtmlScraper sharedInstance] richTextFromHtml:content].copy;
    NSLog(@"attribute:%@",_atttibutedString);

    _authorLabel.text = [self urldecode:_postDetailModel.author];
    _timeLabel.text = [self urldecode:_postDetailModel.dateline];
    _contentLabel.attributedText = _atttibutedString;
    _countLabel.text = [NSString stringWithFormat:@"#%ld",(long)_count];
    
    [self updateConstraints];
}

#pragma mark - Action
- (void)didReplyButtonClicked {
    if (_delegate && [_delegate respondsToSelector:@selector(didClickReplyButtonAtIndexPath:)]) {
        [_delegate didClickReplyButtonAtIndexPath:_indexPath];
    }
}

@end
