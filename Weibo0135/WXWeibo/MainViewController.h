//
//  MainViewController.h
//  WXWeibo
//
//  Created by 周城 on 14-5-6.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "ProfileViewController.h"
#import "DiscoverViewController.h"
#import "MoreViewController.h"
#import "BaseNavigationController.h"


@interface MainViewController : UITabBarController<SinaWeiboDelegate,HomeViewControllerDelegate,UINavigationControllerDelegate> {
    UIView *_tabbarView;
    UIImageView *_sliderView;
    UIImageView *_badgeView;
    
    HomeViewController *_homeCtrl;
}

-(void)showTabbar:(BOOL)show;

@end
