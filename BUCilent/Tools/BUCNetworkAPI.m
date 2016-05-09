//
//  BUCNetworkAPI.m
//  BUCilent
//
//  Created by dito on 16/5/8.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCNetworkAPI.h"

@implementation BUCNetworkAPI

NSString *const kApiLogin = @"/open_api/bu_logging.php";
NSString *const kApiForumList = @"/open_api/bu_forum.php";
NSString *const kApiThread = @"/open_api/bu_thread.php";
NSString *const kApiPostDetail = @"/open_api/bu_post.php";
NSString *const kApiNewPost = @"/open_api/bu_newpost.php";
NSString *const kApiAccountDetail = @"/open_api/bu_profile.php";
NSString *const kApiForumTag = @"/open_api/bu_forumtag.php";
NSString *const kApiFidTidCount = @"/open_api/bu_logging.php";
NSString *const kApiHome = @"/open_api/bu_home.php";

NSString *const kLPNetworkRequestShowEmptyPageWhenError = @"kLPNetworkRequestShowEmptyPageWhenError";

+ (NSString *)requestURL:(NSString *)requestURL {
    NSURL *URL = [NSURL URLWithString:[self baseURL]];
    return [NSString stringWithFormat:@"%@%@", [self baseURL], requestURL];
}


+ (NSString *)baseURL {
    return @"http://out.bitunion.org";
#ifdef DEBUG
    return @"http://ydsj.didaaa.com";
#else
    return @"http://ydsj.didaaa.com";
#endif
}

@end
/*
 http://www.bitunion.org/open_api/bu_logging.php     登录
 
 http://www.bitunion.org/open_api/bu_logging.php  退出
 
 
 http://www.bitunion.org/open_api/bu_forum.php  论坛列表
 
 http://www.bitunion.org/open_api/bu_thread.php  查询论坛帖子
 
 http://www.bitunion.org/open_api/bu_post.php   查询帖子详情
 
 http://www.bitunion.org/open_api/bu_profile.php   查询用户详情
 
 
 http://www.bitunion.org/open_api/bu_newpost.php  回复帖子
 
 
 
 http://www.bitunion.org/open_api/bu_forumtag.php  //查询论坛分类
 
 http://www.bitunion.org/open_api/bu_newpost.php  发布新帖
 
 http://www.bitunion.org/open_api/bu_home.php  查询论坛最新帖子
 
 ：http://www.bitunion.org/open_api/bu_fid_tid.php
 
 
 */