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
#import "BUCTextAttachment.h"

#import "UIImageView+WebCache.h"
#import "BUCImageFullScreen.h"
#import "BUCPostDetailCell+Reply.h"

const CGFloat kDetailCellLeftPadding = 12;
const CGFloat kDetailCellTopPadding = 12;

@interface BUCPostDetailCell () <UITextViewDelegate>

@end

@implementation BUCPostDetailCell {
    UIImageView *_avatarImageView;
    UILabel *_authorLabel;
    UILabel *_timeLabel;
    UILabel *_countLabel;
    UIView *_backgroundView;
    
    UITextView *_contentTextView;
    UIButton *_replyButton;
    UIView *_separatorLine;
    UIView *_separatorLineTop;
    UIImageView *_attachmentImageView;
    
    NSAttributedString *_atttibutedString;
    
}

+ (NSString *)cellReuseIdentifier {
    return @"BUCPostDetailCellReuseIdentifier";
}

- (void)setupViews {
    [super setupViews];
    
    _backgroundView = [[UIView alloc] init];
    _backgroundView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    [self.contentView addSubview:_backgroundView];
    
    _avatarImageView = [[UIImageView alloc] init];
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_backgroundView addSubview:_avatarImageView];

    _authorLabel = [[UILabel alloc] init];
    _authorLabel.textColor = [UIColor blackColor];
    _authorLabel.font = [UIFont systemFontOfSize:13];
    _authorLabel.textAlignment = NSTextAlignmentRight;
    [_backgroundView addSubview:_authorLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor blackColor];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [_backgroundView addSubview:_timeLabel];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.textColor = [UIColor blackColor];
    _countLabel.font = [UIFont systemFontOfSize:13];
    _countLabel.textAlignment = NSTextAlignmentRight;
    [_backgroundView addSubview:_countLabel];
    
    _separatorLineTop = [[UIView alloc] init];
    _separatorLineTop.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    [_backgroundView addSubview:_separatorLineTop];
    
    _contentTextView = [[UITextView alloc] init];
    _contentTextView.scrollEnabled = NO;
    _contentTextView.editable= NO;
    _contentTextView.delegate = self;
    [self.contentView addSubview:_contentTextView];
    
    _replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_replyButton setTitle:@"回复" forState:UIControlStateNormal];
    _replyButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_replyButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_replyButton addTarget:self action:@selector(didReplyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_replyButton];
    
    _separatorLine = [[UIView alloc] init];
    _separatorLine.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    [self.contentView addSubview:_separatorLine];
    
    _attachmentImageView = [[UIImageView alloc] init];
    _attachmentImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_attachmentImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didAttachmentTap)];
    _attachmentImageView.userInteractionEnabled = YES;
    [_attachmentImageView addGestureRecognizer:tap];
    
    [self setupConstraints];

}

- (void)setupConstraints {
    [_backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
    }];
    
    [_avatarImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backgroundView.mas_top).offset(kDetailCellTopPadding);
        make.left.equalTo(self.contentView).offset(kDetailCellLeftPadding);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.bottom.equalTo(_backgroundView.mas_bottom).offset(-kDetailCellTopPadding / 2);
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
        make.bottom.equalTo(_avatarImageView.mas_bottom).offset(kDetailCellTopPadding / 2);
        make.left.equalTo(_avatarImageView.mas_left);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    [_contentTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarImageView.mas_bottom).offset(kDetailCellTopPadding);
        make.left.equalTo(self.contentView).offset(kDetailCellLeftPadding);
        make.right.equalTo(self.contentView).offset(-kDetailCellLeftPadding);
        if (!_postDetailModel.attachment) {
            make.bottom.equalTo(self.contentView).offset(-2 * kDetailCellTopPadding);
        }
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
}


- (void)setPostDetailModel:(BUCPostDetailModel *)postDetailModel {
    _postDetailModel = postDetailModel;

    _authorLabel.text = [self urldecode:_postDetailModel.author];
    _timeLabel.text = [self parseDateline:_postDetailModel.dateline];
    
    if (_postDetailModel.attachment) {
        NSString *attachment = [NSString stringWithFormat:@"%@/%@", @"http://out.bitunion.org", [self urldecode:_postDetailModel.attachment]];
        NSURL *attachmentUrl = [NSURL URLWithString:attachment];
        [_attachmentImageView sd_setImageWithURL:attachmentUrl placeholderImage:[UIImage imageNamed:@"loading"]];
    }
    
    [_avatarImageView sd_setImageWithURL:[[BUCHtmlScraper sharedInstance] avatarUrlFromHtml:[self urldecode:_postDetailModel.avatar]] placeholderImage:[UIImage imageNamed:@"avatar"]];
    _countLabel.text = [NSString stringWithFormat:@"#%ld",(long)_count];
    
    [self updateConstraints];
}

- (void)setAttributedString:(NSAttributedString *)attributedString {
    _attributedString = attributedString;
    if (_attributedString) {
        _contentTextView.attributedText = attributedString;
    }
}

- (void)updateConstraints {
    [_contentTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarImageView.mas_bottom).offset(kDetailCellTopPadding);
        make.left.equalTo(self.contentView).offset(kDetailCellLeftPadding);
        make.right.equalTo(self.contentView).offset(-kDetailCellLeftPadding);
        if (!_postDetailModel.attachment) {
            make.bottom.equalTo(self.contentView).offset(-2 * kDetailCellTopPadding);
        }
    }];
    
    [_attachmentImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(_contentTextView.mas_bottom).offset(kDetailCellTopPadding / 2);
        if (_attachmentImageView.image.size.height < 250) {
            make.size.mas_equalTo(_attachmentImageView.image.size);
        } else {
            make.size.mas_equalTo(CGSizeMake(250, 250));
        }
        
        if (_postDetailModel.attachment) {
            _attachmentImageView.hidden = NO;
            make.bottom.equalTo(self.contentView).offset(-2 * kDetailCellTopPadding);
        } else {
            _attachmentImageView.hidden = YES;
        }
    }];
    
    [super updateConstraints];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = textAttachment.image;
    [BUCImageFullScreen showImageFullScreen:imageView];
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    return YES;
}

#pragma mark - Action
- (void)didReplyButtonClicked {
    [self replyWithPostDetail:_postDetailModel];
}

- (void)didAttachmentTap {
    if (_attachmentImageView.image) {
        [BUCImageFullScreen showImageFullScreen:_attachmentImageView];
    }
}

@end
