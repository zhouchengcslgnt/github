//
//  BaseViewController.m
//  WXWeibo
//
//  Created by wei.chen on 13-1-21.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"
#import "UIFactory.h"
#import "MBProgressHUD.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

-(void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
    [super dealloc];
    [_requests release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isBackButton = YES;
        self.isCacelButton = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _requests = [[NSMutableArray alloc] init];//初始化请求对象的数组

    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && self.isBackButton) {
        UIButton *button = [UIFactory createButton:@"navigationbar_back.png" highlighted:@"navigationbar_back_highlighted.png"];
        button.frame = CGRectMake(0, 0, 24, 24);
        button.showsTouchWhenHighlighted = YES;//点击显示高亮动画
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = [backItem autorelease];
    }
    
    if (self.isCacelButton) {
        //创建导航按钮
        ThemeButton *button = [UIFactory createNavigationButton:CGRectMake(0, 0, 45, 30) title:@"取消" target:self action:@selector(cancleAction)];
        UIBarButtonItem *cancleButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = [cancleButtonItem autorelease];
    }
}

//内存不足时调用的方法
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (WXHLOSVersion() >= 6.0) {
        //判断当前控制器的视图是否显示，widow!=nil是显示，反之是不显示
        if (self.view.window == nil) {
            self.view = nil;
            //兼容6.0之前的内存管理
            [self viewDidLoad];
        }
    }
}

//6.0之前
-(void)viewDidUnload
{
    [super viewDidUnload];
}

//在界面消失是结束请求
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    for (SinaWeiboRequest *request in _requests) {
        [request disconnect];//结束请求
    }
}

//导航返回
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

//导航取消
-(void)cancleAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//override
//设置导航栏上的标题
- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    titleLabel.textColor = [UIColor blackColor];
    UILabel *titleLabel = [UIFactory createLabel:kNavigationBarTitleLabel];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    [titleLabel sizeToFit];
    
    self.navigationItem.titleView = titleLabel;
}

- (SinaWeibo *)sinaweibo {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaweibo = appDelegate.sinaweibo;
    return sinaweibo;
}

-(AppDelegate *)appDelegate
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate;
}

-(void)showHUD:(NSString *)title isBim:(BOOL)isDim
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.dimBackground = isDim;
    self.hud.labelText = title;
}
- (void)hideHUD:(BOOL)animated
{
    [self.hud hide:animated];
}
- (void)hideHUD:(BOOL)animated afterDelay:(NSTimeInterval)delay
{
    [self.hud hide:animated afterDelay:(delay)];
}
- (void)showHUDComplete:(NSString *)title
{
    self.hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
    self.hud.mode = MBProgressHUDModeCustomView;
    if (title.length > 0) {
        self.hud.labelText = title;
    }
    [self.hud hide:YES afterDelay:1];
}

//在状态栏显示提示
- (void)showStatusTip:(BOOL)show title:(NSString *)title
{
    if (_tipWindow == nil) {
        _tipWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        _tipWindow.windowLevel = UIWindowLevelStatusBar;
        _tipWindow.backgroundColor = [UIColor blackColor];
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.font = [UIFont systemFontOfSize:13];
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.tag = 1;
        [_tipWindow addSubview:tipLabel];
        [tipLabel release];
        
        //加上动态效果
        UIImageView *progress = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"queue_statusbar_progress.png"]];
        progress.frame = CGRectMake(0, 20-6, 100, 6);
        progress.tag = 2;
        [_tipWindow addSubview:progress];
        [progress release];
    }
    
    UILabel *tipLabel = (UILabel *)[_tipWindow viewWithTag:1];
    tipLabel.text = title;
    UIImageView *progress = (UIImageView *)[_tipWindow viewWithTag:2];
    
    if (show) {
        _tipWindow.hidden = NO;
        
        //动态
        progress.left = 0;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:2];//间隔时间
        [UIView setAnimationRepeatCount:1000];//循环次数
        //移动方式
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        progress.left = ScreenWidth;
        [UIView commitAnimations];
        
    }else{
        progress.hidden = true;
        [self performSelector:@selector(removeTipWindow) withObject:nil afterDelay:1.5];
    }
        
}

-(void)removeTipWindow
{
    _tipWindow.hidden = YES;
    [_tipWindow autorelease];
    _tipWindow = nil;//安全释放
}


@end
