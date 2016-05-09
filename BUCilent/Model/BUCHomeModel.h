//
//  BUCHomeModel.h
//  BUCilent
//
//  Created by dito on 16/5/9.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCBaseModel.h"

@interface BUCHomeModel : BUCBaseModel

@property (nonatomic, copy) NSString *author;
@property (nonatomic, strong) NSURL *avatar;
@property (nonatomic, strong) NSNumber *fid;
@property (nonatomic, strong) NSNumber *fidSum;
@property (nonatomic, strong) NSNumber *tid;
@property (nonatomic, strong) NSNumber *tidSum;
@property (nonatomic, copy) NSString *fname;
@property (nonatomic, copy) NSString *pname;

@property (nonatomic, strong) NSDictionary *lastRelpyDict;

//@property (nonatomic, )


@end
