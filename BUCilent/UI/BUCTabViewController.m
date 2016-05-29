//
//  BUCTabViewController.m
//  BUCilent
//
//  Created by dito on 16/5/8.
//  Copyright © 2016年 zouzhigang. All rights reserved.
//

#import "BUCTabViewController.h"
#import "BUCHomeViewController.h"
#import "BUCDiscoverViewController.h"
#import "BUCMyProfileViewController.h"

@interface BUCTabViewController ()

@end

@implementation BUCTabViewController {
    BUCHomeViewController *_homeVC;
    BUCDiscoverViewController *_discoverVC;
    BUCMyProfileViewController *_myProfileVC;

}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI {
    [[UITabBar appearance] setBackgroundImage:[self imageWithColor:[UIColor whiteColor]]];
    
    _homeVC = [[BUCHomeViewController alloc] init];
    _discoverVC = [[BUCDiscoverViewController alloc] init];
    _myProfileVC = [[BUCMyProfileViewController alloc] init];
    
    UINavigationController *_homeNavigationController =
    [[UINavigationController alloc] initWithRootViewController:_homeVC];
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:17],
                                  NSForegroundColorAttributeName: [UIColor blackColor]};
    [_homeNavigationController.navigationBar setTitleTextAttributes:attributes];

    
    
    UINavigationController *_discoveryNavigationController =
    [[UINavigationController alloc] initWithRootViewController:_discoverVC];
    UINavigationController *_myProfileNavigationController =
    [[UINavigationController alloc] initWithRootViewController:_myProfileVC];
    
    NSArray *controllers = @[_homeNavigationController,
                             _discoveryNavigationController,
                             _myProfileNavigationController];
    self.viewControllers = controllers;
    self.selectedIndex = 0;
    
    UITabBarItem *homeItem =
    [[UITabBarItem alloc] initWithTitle:@"首页"
                                  image:[[UIImage imageNamed:@"Tabbar_Home_Down"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                          selectedImage:[[UIImage imageNamed:@"Tabbar_Home_Up"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UITabBarItem *discoveryItem =
    [[UITabBarItem alloc] initWithTitle:@"发现"
                                  image:[[UIImage imageNamed:@"Tabbar_Discovery_Down"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                          selectedImage:[[UIImage imageNamed:@"Tabbar_Discovery_Up"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UITabBarItem *myProfileItem =
    [[UITabBarItem alloc] initWithTitle:@"我的"
                                  image:[[UIImage imageNamed:@"Tabbar_MyProfile_Down"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                          selectedImage:[[UIImage imageNamed:@"Tabbar_MyProfile_Up"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    _homeNavigationController.tabBarItem = homeItem;
    _discoveryNavigationController.tabBarItem = discoveryItem;
    _myProfileNavigationController.tabBarItem = myProfileItem;
    
    [homeItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor lightGrayColor], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [discoveryItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor lightGrayColor], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [myProfileItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor lightGrayColor], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
}



#pragma mark - image and color

- (UIImage *)imageWithColor:(UIColor *)color {
    NSParameterAssert(color != nil);
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
