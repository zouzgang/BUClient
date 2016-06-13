//
//  CPMailCompose.h
//  confPlus
//
//  Created by dengjiebin on 11/19/15.
//  Copyright © 2015 Loopeer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPMailCompose : NSObject

+ (instancetype)sharedInstance;


- (void)send:(NSString *)subject toRecipients:(NSArray *)toRecipients messageBody:(NSString *)messageBody isHTML:(BOOL)isHTML controller:(UIViewController *)controller;

@end
