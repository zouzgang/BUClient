//
//  BUCNetworkAPI.h
//  BUCilent
//
//  Created by dito on 16/5/8.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BUCNetworkAPI : NSObject

//BITOpenAPI
extern NSString *const kApiLogin;/**<登录*/
extern NSString *const kApiForumList;/**<论坛列表*/
extern NSString *const kApiThread;/**<查询论坛帖子*/
extern NSString *const kApiPostDetail;/**<查询帖子详情*/
extern NSString *const kApiNewPost;/**<回复帖子  发表新帖*/
extern NSString *const kApiAccountDetail;/**<查看用户详情*/
extern NSString *const kApiHome;/**<查询论坛最新帖子*/
extern NSString *const kApiForumTag;/**<查询论坛分类*/
extern NSString *const kApiFidTidCount;/**<登录*/
extern NSString *const kApiTidOrFid;/**<楼层数*/


//api form spider
extern NSString *const kApiFavorite;/**<收藏*/
extern NSString *const kApiFavoriteList;/**<收藏列表*/

+ (NSString *)baseURL;

+ (NSString *)requestURL:(NSString *)requestURL;

@end
