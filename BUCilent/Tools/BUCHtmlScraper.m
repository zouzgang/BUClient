//
//  BUCHtmlScraper.m
//  BUCilent
//
//  Created by dito on 16/5/9.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCHtmlScraper.h"
#include "TFHpple.h"
#import "BUCTextAttachment.h"
#import "UIColor+BUC.h"
#import "UIImage+BUCImage.h"

#define kMessageTextFont   [UIFont systemFontOfSize:16]

@implementation BUCHtmlScraper {
    
}
#pragma mark - init
+ (BUCHtmlScraper *)sharedInstance {
    static BUCHtmlScraper *sharedInstance;
    static dispatch_once_t onceSecurePredicate;
    dispatch_once(&onceSecurePredicate, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Public Methods
- (NSMutableAttributedString *)richTextFromHtml:(NSString *)html {
    return [self richTextFromHtml:html textStyle:UIFontTextStyleBody trait:0];
}


- (NSMutableAttributedString *)richTextFromHtml:(NSString *)html textStyle:(NSString *)style {
    return [self richTextFromHtml:html textStyle:style trait:0];
}


- (NSMutableAttributedString *)richTextFromHtml:(NSString *)html textStyle:(NSString *)style trait:(uint32_t)trait {
    return [self richTextFromTree:[self treeFromHtml:html] attributes:nil];
}


- (NSMutableAttributedString *)richTextFromHtml:(NSString *)html attributes:(NSDictionary *)attributes {
    return [self richTextFromTree:[self treeFromHtml:html] attributes:attributes];
}


///////处理用户头像
- (NSURL *)avatarUrlFromHtml:(NSString *)html {
    if (!html || html.length == 0 ) {
        return nil;
    }
    
    NSData *htmlData = [html dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *parser = [TFHpple hppleWithHTMLData:htmlData];
    NSString *query = @"//body";
    NSArray *nodes = [[[parser searchWithXPathQuery:query] firstObject] children];
    
    NSString *source = [[nodes firstObject] objectForKey:@"src"];
    return [self parseImageUrl:source];
}

- (NSURL *)parseImageUrl:(NSString *)source {
    NSURL *url = [NSURL URLWithString:source];
    
    if ([url.host isEqualToString:@"bitunion.org"] || [url.host isEqualToString:@"v6.bitunion.org"]) {
        source = [NSString stringWithFormat:@"%@%@", @"http://out.bitunion.org", url.path];
    } else if (matchPattern(source, @"^http://www\\.bitunion\\.org/.+$", NULL)) {
        //        source = [source stringByReplacingOccurrencesOfString:@"http://www.bitunion.org" @"http://out.bitunion.org"];
    } else if (matchPattern(source, @"^images/.+$", NULL)) {
        source = [NSString stringWithFormat:@"%@/%@", @"http://out.bitunion.org", source];
    } else if (matchPattern(source, @"^/attachments/.+$", NULL)) {
        source = [NSString stringWithFormat:@"%@%@", @"http://out.bitunion.org", source];
    }
    
    return [NSURL URLWithString:source];
}


BOOL matchPattern(NSString *string, NSString *pattern, NSTextCheckingResult **match) {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:NULL];
    
    NSTextCheckingResult *output = [regex firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
    
    if (output.numberOfRanges > 0) {
        if (match) {
            *match = output;
        }
        
        return YES;
    }
    
    return NO;
}




#pragma mark - 对NSMutableString 进行处理
-(TFHppleElement *)treeFromHtml:(NSString *)html {
    if (!html || html.length == 0) {
        return nil;
    }
    ///////测试用html
    //     html = @"<a href=\"javascript:;\" dataitem=\"name_付之一笑\" >@付之一笑</a>";
    
    
    
    TFHpple *parser = [TFHpple hppleWithHTMLData:[html dataUsingEncoding:NSUTF8StringEncoding]];
    TFHppleElement *body = [[parser searchWithXPathQuery:@"//body"] firstObject];
    
    if (!body || !body.children || body.children.count == 0) {
        return nil;
    }

    return body;
}

-(NSMutableAttributedString *) richTextFromTree:(TFHppleElement *)tree attributes:(NSDictionary *)attributes {
    if (!tree) {
        return nil;
    }
    
    NSMutableAttributedString *output = [[NSMutableAttributedString alloc] init];
    for (TFHppleElement *node in tree.children) {
        if ([node.tagName isEqualToString:@"br"] || [[node objectForKey:@"id"] isEqualToString:@"id_open_api_label"]) {
            continue;
        }
        [self appendNode:node output:output superAttributes:attributes];
        
    }
    
    if (output.length == 0) {
        return nil;
    }
    
    NSDictionary *messageDict = @{NSFontAttributeName:kMessageTextFont};
    [output addAttributes:messageDict range:NSMakeRange(0, output.length)];
    return output;
}

-(void)appendNode:(TFHppleElement *)node output:(NSMutableAttributedString *)output superAttributes:(NSDictionary *)superAttributes {
    NSString *tagName = node.tagName;
//    NSLog(@"tagname =      %@",tagName);
    if ([node isTextNode]) {//纯文本节点
        NSString *content = node.content;
        content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (content.length == 0)
            return;
        
        [output appendAttributedString:[[NSAttributedString alloc] initWithString:content]];
        return;
    }
    //todo
        if ([tagName isEqualToString:@"img"]) {
            NSString *src = [node objectForKey:@"src"];
//             NSLog(@"src =      %@", src);
            
            if (!src || src.length == 0)
                return;
            
            if ([src containsString:@"gif"]) {
                //gif
                NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
                NSString *path = [NSString stringWithFormat:@"%@/%@", resourcePath, [src lastPathComponent]];
                NSData *data = [NSData dataWithContentsOfFile:path];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:path] size:CGSizeZero];
                
                if (!image)
                    return;
                
                BUCTextAttachment *attachment = [[BUCTextAttachment alloc] init];
                if (image.size.width <= 20.0f) {
                    attachment.bounds = CGRectMake(0, 0, 25, 25);
                } else {
                    attachment.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
                }
                attachment.image = image;
                [output appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
            } else {
                //url
                BUCTextAttachment *attachment = [[BUCTextAttachment alloc] init];
                attachment.bounds = CGRectMake(0, 0, 200, 200);
                attachment.url = [self parseImageUrl:src];
                [output appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
            }

            return;
        }
    
    if ([tagName isEqualToString:@"br"]) {
//        [output appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        return;
    }
    
    NSMutableAttributedString *stringTemp = [[NSMutableAttributedString alloc] init];
    if ([node hasChildren]) {
        NSArray *array = node.children;
        for (TFHppleElement *e in array) {
            [self appendNode:e output:stringTemp superAttributes:superAttributes];
        }
    }
    
    if ( [tagName isEqualToString:@"table"]) {
        [stringTemp appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    }
    
    UIColor *color;
    CGFloat size = [UIFont systemFontSize];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    if ([tagName isEqualToString:@"a"]) {
        NSString *herf = [node objectForKey:@"herf"];
        if (herf)
            [attributes setObject:herf forKey:NSLinkAttributeName];
    }
    
    if ([tagName isEqualToString:@"b"]) {
        [attributes setObject:[UIFont boldSystemFontOfSize:size] forKey:NSFontAttributeName];
    }
    
    NSMutableParagraphStyle *paragraphStyle ;
    if ([tagName isEqualToString:@"i"] && [[node objectForKey:@"class"] isEqualToString:@"pstatus"]) {
        paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attributes setObject:[UIColor yellowColor] forKey:NSForegroundColorAttributeName];
    } else if ([tagName isEqualToString:@"i"]) {
        [attributes setObject:@0.5 forKey:NSObliquenessAttributeName];
    } else {
        if ([node objectForKey:@"align"]) {
            
        }
    }
    
    if ([node objectForKey:@"color"]) {
        [attributes setObject:[UIColor blueColor] forKey:NSForegroundColorAttributeName];
    }
    
    if ([tagName isEqualToString:@"u"] || [tagName isEqualToString:@"a"]) {
        [attributes setObject:@(NSUnderlineStyleThick) forKey:NSUnderlineStyleAttributeName];
    }
    
    if (paragraphStyle) {
        [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    }
    
    if ([tagName isEqualToString:@"blockquote"] || [tagName isEqualToString:@"table"]) {
        [attributes setObject:[UIColor colorWithHexString:@"#F3F3F3"] forKey:NSBackgroundColorAttributeName];
        [attributes setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
        paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineSpacing = 5;
        
        paragraphStyle.alignment = NSTextAlignmentJustified;
        paragraphStyle.paragraphSpacingBefore = 10.0;
        paragraphStyle.hyphenationFactor = 1.0;
        paragraphStyle.paragraphSpacing = 5;
        
        [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    } else {
        if ([node objectForKey:@"style"]) {
            
        }
    }
    
    NSRange range = NSMakeRange(0, stringTemp.length);
    [stringTemp addAttributes:attributes range:range];
    [stringTemp fixAttributesInRange:range];
    [output appendAttributedString:stringTemp];
}






@end
