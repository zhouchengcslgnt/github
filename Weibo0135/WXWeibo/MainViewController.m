//
//  MainViewController.m
//  WXWeibo
//
//  Created by 周城 on 14-5-6.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "MainViewController.h"
#import "UIFactory.h"
#import "ThemeButton.h"
#import "AppDelegate.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //隐藏自身的tabar
        [self.tabBar setHidden:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self _initViewController];
    [self _initTabbarView];
    
    //创建一个定时器，定时刷新未读的微博
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//隐藏tabbar
-(void)showTabbar:(BOOL)show
{
    //加个动画
    [UIView animateWithDuration:0.5 animations:^{
        if (show) {
            _tabbarView.left = 0;
        }else{
            _tabbarView.left = -ScreenWidth;
        }
    }];
    
    [self _resizeView:show];
}

-(void)_resizeView:(BOOL)showTabbar
{
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITransitionView")]) {
            if (showTabbar) {
                subView.height = ScreenHeight - 49-20;
            }else{
                subView.height = ScreenHeight - 20;
            }
        }
    }
}

//初始化子控制器
- (void)_initViewController {
    _homeCtrl = [[HomeViewController alloc] init];
    _homeCtrl.homeViewControllerDelegate = self;
    MessageViewController *message = [[[MessageViewController alloc] init] autorelease];
    ProfileViewController *profile = [[[ProfileViewController alloc] init] autorelease];
    DiscoverViewController *discover = [[[DiscoverViewController alloc] init] autorelease];
    MoreViewController *more = [[[MoreViewController alloc] init] autorelease];
    
    NSArray *views = @[_homeCtrl,message,profile,discover,more];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:5];
    for (UIViewController *viewController in views) {
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:viewController];
        [viewControllers addObject:nav];
        [nav release];
        nav.delegate = self;
    }
    
    self.viewControllers = viewControllers;
    
}

//创建自定义tabBar
- (void)_initTabbarView {
    float version = WXHLOSVersion();
    if (version >= 7.0) {
        _tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-49, ScreenWidth, 49)];
    }else{
       _tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-49-20, ScreenWidth, 49)];
    }
    
    [self.view addSubview:_tabbarView];
    
    UIImageView *tabbarGroundImage = [UIFactory createImageView:@"tabbar_background.png"];
    tabbarGroundImage.frame = _tabbarView.bounds;
    [_tabbarView addSubview:tabbarGroundImage];
    
    NSArray *backgroud = @[@"tabbar_home.png",@"tabbar_message_center.png",@"tabbar_profile.png",@"tabbar_discover.png",@"tabbar_more.png"];
    
    NSArray *heightBackground = @[@"tabbar_home_highlighted.png",@"tabbar_message_center_highlighted.png",@"tabbar_profile_highlighted.png",@"tabbar_discover_highlighted.png",@"tabbar_more_highlighted.png"];
    
    for (int i=0; i<backgroud.count; i++) {
        NSString *backImage = backgroud[i];
        NSString *heightImage = heightBackground[i];
        
//        ThemeButton *button = [[ThemeButton alloc] initWithImage:backImage highlighted:heightImage];
        ThemeButton *button = [UIFactory createButton:backImage highlighted:heightImage];
        button.frame = CGRectMake((64-30)/2+(i*64), (49-30)/2, 30, 30);
        button.tag = i;
        [button addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [_tabbarView addSubview:button];
    }
    
    // 显示下划线
    _sliderView = [[UIFactory createImageView:@"tabbar_slider.png"] retain];
    _sliderView.backgroundColor = [UIColor clearColor];
    _sliderView.frame = CGRectMake((64-15)/2, 5, 15, 44);
    [_tabbarView addSubview:_sliderView];
    
    _badgeView = [UIFactory createImageView:@"main_badge.png"];//初始化 未读数量显示
    [_tabbarView addSubview:_badgeView];
    _badgeView.hidden = YES;//默认隐藏
    _badgeView.frame = CGRectMake(64-25, 5, 20, 20);
}

-(void)refreshUnReadView:(NSDictionary *)result
{
    //新微博未读数
    NSNumber *status = [result objectForKey:@"status"];
    NSLog(@"result:%@",status);
    
    if (_badgeView != nil) {
        
        UILabel *badgeLabel = [[UILabel alloc] initWithFrame:_badgeView.bounds];
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.backgroundColor = [UIColor clearColor];
        badgeLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        badgeLabel.textColor = [UIColor purpleColor];
        badgeLabel.tag = 1;
        [_badgeView addSubview:badgeLabel];
        [badgeLabel autorelease];
        
        int n = [status intValue];
        if (n > 0) {
            UILabel *badgeLabel = (UILabel *)[_badgeView viewWithTag:1];
            if (n > 99) {
                n = 99;
            }
            badgeLabel.text = [NSString stringWithFormat:@"%d",n];
            _badgeView.hidden = NO;
        }else{
            _badgeView.hidden = YES;
        }
    }
}

#pragma mark - loaddata
//请求刷新未读数
-(void)loadUnReadData
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaweibo = appDelegate.sinaweibo;
    [sinaweibo requestWithURL:@"remind/unread_count.json" params:nil httpMethod:@"GET" block:^(NSDictionary * result){
        [self refreshUnReadView:result];
        
    }];
}

#pragma mark - actions
//tab 按钮的点击事件
- (void)selectedTab:(UIButton *)button {
    
    //加高亮的动画
    button.showsTouchWhenHighlighted = YES;
    
    //判断是否重复点击,第一个界面,并且 有未读数字显示
    if (button.tag == self.selectedIndex && button.tag == 0 && _badgeView.hidden == NO) {
        [_homeCtrl refreshWeibo];//刷新微博
    }
    
    //
    self.selectedIndex = button.tag;
    
    //下划线的动画
    float x = button.left + (button.width-_sliderView.width)/2;
    [UIView animateWithDuration:0.2 animations:^{
        _sliderView.left = x;
    }];
}

#pragma mark - timerAction
-(void)timerAction:(NSTimer *)timer
{
    [self loadUnReadData];
    
}

#pragma mark - SinaWeibo delegate
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo {
    //保存认证的数据到本地
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //加载数据
    [_homeCtrl loadWeiboData];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo {
    //移除认证的数据
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo {
    NSLog(@"sinaweiboLogInDidCancel");    
}

#pragma mark - HomeViewControllerDelegate
-(void)didFinishpulldownData
{
    _badgeView.hidden = YES;//隐藏未读数
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    int count = navigationController.viewControllers.count;
    if (count >= 2) {
        [self showTabbar:NO];
    }else{
        [self showTabbar:YES];
    }
}

@end
