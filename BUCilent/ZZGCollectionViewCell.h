//
//  ZZGCollectionViewCell.h
//  ZZGViewPager
//
//  Created by dito on 16/4/18.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZGCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *title;

+ (NSString *)cellReuseIdentifier;

@end
