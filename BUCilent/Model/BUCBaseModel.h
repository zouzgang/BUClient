//
//  BUCBaseModel.h
//  BUCilent
//
//  Created by dito on 16/5/9.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MTLJSONAdapter.h>
#import "MTLModel.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"

@interface BUCBaseModel : MTLModel <MTLJSONSerializing>

@end
