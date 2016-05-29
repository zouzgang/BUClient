//
//  CPEventFilterView.h
//  confPlus
//
//  Created by dito on 16/5/23.
//  Copyright © 2016年 Loopeer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPEventFilterView : UIView

- (void)showInView:(UIView *)view titles:(NSArray *)titles completehandler:(void(^)(NSInteger index))completehandler;

@end
