//
//  BUCPostDetailModelDealer.m
//  BUCilent
//
//  Created by dito on 16/6/13.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCPostDetailModelDealer.h"
#import "BUCPostDetailCell.h"
#import "BUCHtmlScraper.h"
#import "BUCStringTool.h"
#import "BUCPostDetailModel.h"
#import "BUCTextAttachment.h"
#import "UIImageView+WebCache.h"

NSString *const kAttributedStringChangedNotification = @"kAttributedStringChangedNotification";/**<通过推送消息启动*/

@implementation BUCPostDetailModelDealer

+ (NSArray *)cacheArray:(NSArray<BUCPostDetailModel *> *)rawArray cacheMap:(NSMutableDictionary *)cacheMap{
    NSMutableArray *arrayM = [NSMutableArray array];
    
    for (NSInteger i = 0; i < rawArray.count; i ++) {
        BUCPostDetailModel *postDetail = rawArray[i];
        NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
        NSAttributedString *attributedString = [self transformAttributeString:postDetail];
        if (attributedString)
            [dictM setObject:attributedString forKey:@"attributedString"];
        CGFloat height = [self cauclateHeight:postDetail attributeString:attributedString];
        if (height)
            [dictM setObject:@(height) forKey:@"height"];
        if (dictM)
            [cacheMap setObject:dictM forKey:postDetail.pid];
    }
    
    return arrayM.copy;
}

+ (CGFloat)cauclateHeight:(BUCPostDetailModel *)postDetailModel attributeString:(NSAttributedString *)arrtributedString{
    CGFloat height;
    
    if (postDetailModel.attachment) {
        height = kDetailCellTopPadding + 50 + kDetailCellTopPadding + [self heightOfContent:arrtributedString].height + kDetailCellTopPadding * 2 + kDetailCellTopPadding / 2 +  250;
    } else {
        height = kDetailCellTopPadding + 50 + kDetailCellTopPadding + [self heightOfContent:arrtributedString].height + kDetailCellTopPadding * 2;
    }

    
    return height;
}

+ (CGSize)heightOfContent:(NSAttributedString *)attributedString {
    NSTextStorage *textStorage = [[NSTextStorage alloc] init];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * kDetailCellLeftPadding - 16, MAXFLOAT)];
    [textContainer setLineFragmentPadding:5.0];
    [layoutManager addTextContainer:textContainer];
    
    if (attributedString)
        [textStorage setAttributedString:attributedString];
    [layoutManager glyphRangeForTextContainer:textContainer];
    [layoutManager ensureLayoutForTextContainer:textContainer];
    
    CGRect frame = [layoutManager usedRectForTextContainer:textContainer];
    return CGSizeMake(frame.size.width, frame.size.height + 20);
}

+ (NSAttributedString *)transformAttributeString:(BUCPostDetailModel *)postDetailModel {
    
    NSMutableString *content = [[NSMutableString alloc] init];
    NSString *title = [BUCStringTool urldecode:postDetailModel.subject];
    if (title) {
        title = [NSString stringWithFormat:@"<b>%@</b>\n\n", title];
        [content appendString:title];
    }
    //////message
    NSString *body = [BUCStringTool urldecode:postDetailModel.message];
    if (body != nil) {
        [content appendString:body];
    }

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    NSMutableAttributedString *atttibutedString = [[BUCHtmlScraper sharedInstance] richTextFromHtml:content].copy;
    
    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithAttributedString:atttibutedString];
    
//    [atttibutedString enumerateAttributesInRange:NSMakeRange(0, atttibutedString.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> *attrs, NSRange range, BOOL *stop) {
//        BUCTextAttachment *attachment = attrs[@"NSAttachment"];
//        if (attachment && attachment.url) {
//            UIImageView *imageView = [[UIImageView alloc] init];
//            imageView.bounds =  attachment.bounds;
//            
//            [imageView sd_setImageWithURL:attachment.url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                BUCTextAttachment *newAttachment = [[BUCTextAttachment alloc] init];
//                newAttachment.image = image;
//                
//                if ((image.size.width / screenWidth) > 1) {
//                    newAttachment.bounds = CGRectMake(0, 0, 250, image.size.height * 250 / image.size.width);
//                } else {
//                    newAttachment.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
//                }
////                NSMutableAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:newAttachment].mutableCopy;
////                
////                [resultString replaceCharactersInRange:range withAttributedString:[NSAttributedString attributedStringWithAttachment:newAttachment]];
////                
////                NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
////                paragraphStyle.alignment = NSTextAlignmentCenter;
////                [resultString addAttributes:@{NSParagraphStyleAttributeName : paragraphStyle} range:NSMakeRange(0, [NSAttributedString attributedStringWithAttachment:newAttachment].length)];
//                
//                
//                NSMutableAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:newAttachment].mutableCopy;
//                NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//                paragraphStyle.alignment = NSTextAlignmentCenter;
//                [attachmentString addAttributes:@{NSParagraphStyleAttributeName : paragraphStyle} range:NSMakeRange(0, attachmentString.length)];
//                [resultString replaceCharactersInRange:range withAttributedString:attachmentString.copy];
//                
////                [[NSNotificationCenter defaultCenter] postNotificationName:kAttributedStringChangedNotification object:nil userInfo:@{@"pid" : postDetailModel.pid, @"attributedString" : resultString}];
//
//            }];
//        }
//    }];

    
    return resultString.copy;
}

@end
