//
//  CPTakePhotoTool.h
//  confPlus
//
//  Created by Han Shuai on 15/11/25.
//  Copyright © 2015年 Loopeer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CPGetPhotoCompletionBlock)(UIImage *image);

@interface CPTakePhotoTool : NSObject

+ (void)didClickGetPhotos:(UIViewController *)viewController completionBlock:(CPGetPhotoCompletionBlock)completionBlock;

+ (void)enterAlbum:(UIViewController *)viewController completionBlock:(CPGetPhotoCompletionBlock)completionBlock;

@end
