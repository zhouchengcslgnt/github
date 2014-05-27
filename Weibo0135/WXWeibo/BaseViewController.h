//
//  BaseViewController.h
//  WXWeibo
//
//  Created by wei.chen on 13-1-21.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "AppDelegate.h"

@class MBProgressHUD;
@interface BaseViewController : UIViewController{
    NSMutableArray *_requests;//用来保存sinaweibo的请求对象
    UIWindow *_tipWindow;
}

@property(nonatomic,assign)BOOL isBackButton;
@property(nonatomic,assign)BOOL isCacelButton;


@property(nonatomic,retain)MBProgressHUD *hud;

- (SinaWeibo *)sinaweibo;

-(AppDelegate *)appDelegate;

- (void)showHUD:(NSString *)title isBim:(BOOL)isDim;
- (void)showHUDComplete:(NSString *)title;
- (void)hideHUD:(BOOL)animated;
- (void)hideHUD:(BOOL)animated afterDelay:(NSTimeInterval)delay;
- (void)showStatusTip:(BOOL)show title:(NSString *)title;

//导航取消
-(void)cancleAction;

@end
