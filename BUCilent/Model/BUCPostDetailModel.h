//
//  BUCPostDetailModel.h
//  BUCilent
//
//  Created by dito on 16/5/9.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCBaseModel.h"

@interface BUCPostDetailModel : BUCBaseModel

@property (nonatomic, strong) NSNumber *pid;
@property (nonatomic, strong) NSNumber *fid;
@property (nonatomic, strong) NSNumber *tid;
@property (nonatomic, strong) NSNumber *aid;
@property (nonatomic, strong) NSNumber *uid;
@property (nonatomic, strong) NSURL *icon;

@property (nonatomic, copy) NSString *author;
@property (nonatomic, strong) NSNumber *authorID;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *dateline;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) NSNumber *usesig;
@property (nonatomic, strong) NSNumber *bbcodeoff;
@property (nonatomic, strong) NSNumber *smileyoff;
@property (nonatomic, strong) NSNumber *parseurloff;
@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, strong) NSNumber *rate;
@property (nonatomic, strong) NSNumber *ratetimes;
@property (nonatomic, strong) NSNumber *pstatus;
//@property (nonatomic, strong) NSNumber *lastedit;'


@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *attachment;
@property (nonatomic, copy) NSString *filesize;
@property (nonatomic, copy) NSString *downloads;

@property (nonatomic, copy) NSString *filename;




@end

