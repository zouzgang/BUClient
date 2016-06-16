//
//  BUCHtmlScraper.h
//  BUCilent
//
//  Created by dito on 16/5/9.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BUCHtmlScraper;

@interface BUCHtmlScraper : NSObject

+ (BUCHtmlScraper *)sharedInstance;

- (NSAttributedString *)richTextFromHtml:(NSString *)html;
- (NSAttributedString *)richTextFromHtml:(NSString *)html attributes:(NSDictionary *)attributes;
- (NSAttributedString *)richTextFromHtml:(NSString *)html textStyle:(NSString *)style;
- (NSAttributedString *)richTextFromHtml:(NSString *)html textStyle:(NSString *)style trait:(uint32_t)trait;

-(NSArray *)HtmlWithData:(NSData *)data XPath:(NSString *)path;
- (NSURL *)avatarUrlFromHtml:(NSString *)html ;

- (NSString *)convertQuote:(NSString *)quote;


@end
