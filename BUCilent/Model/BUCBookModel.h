//
//  BUCBookModel.h
//  BUCilent
//
//  Created by dito on 16/5/29.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BUCBookModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *tid;

- (instancetype)initModelWithTid:(NSString *)tid title:(NSString *)title;


@end
