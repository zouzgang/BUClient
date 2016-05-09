//
//  BUCLoadingView.h
//  BUCilent
//
//  Created by dito on 16/5/9.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BUCLoadingView : UIView

@property (nonatomic, copy) NSString *loadingText;

- (void)startAnimation;
- (void)stopAnimation;

@end
