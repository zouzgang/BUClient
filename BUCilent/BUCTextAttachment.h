//
//  BUCTextAttachment.h
//  BUCilent
//
//  Created by dito on 16/5/28.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BUCTextAttachment : NSTextAttachment

@property (nonatomic) NSUInteger glyphIndex;
@property (nonatomic) NSURL *url;
@property (nonatomic) NSString *path;
@property (nonatomic) NSInteger tag;


@end
