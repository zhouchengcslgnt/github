//
//  UserViewController.m
//  WXWeibo
//
//  Created by 周城 on 14-5-4.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "UserViewController.h"
#import "UserInfoView.h"
#import "UserModel.h"
#import "WeiboModel.h"
#import "UIFactory.h"

@interface UserViewController ()

@end

@implementation UserViewController

- (void)dealloc {
    [_tableView release];
    [_userInfo release];
    [_userName release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人资料";
    
    self.tableView.eventDelegate = self;
   
    _userInfo = [[UserInfoView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    [super showHUD:@"正在加载..." isBim:NO];
    self.tableView.hidden = YES;
    [self loadWeiboData];//获取微博列表数据
    [self loadUserData];//获取数据
    
    //导航栏上加上 跳转到主页的按钮
    UIButton *homeButton = [UIFactory createButtonWithBackground:@"tabbar_home.png" backgroundHighlighted:@"tabbar_home_highlighted.png"];
    homeButton.frame = CGRectMake(0, 0, 34, 27);
    [homeButton addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homeItem = [[UIBarButtonItem alloc] initWithCustomView:homeButton];
    self.navigationItem.rightBarButtonItem = [homeItem autorelease];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

//请求用户数据
-(void)loadUserData
{
    if (self.userName.length == 0) {
        NSLog(@"error:用户为空");
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.userName forKey:@"screen_name"];
    SinaWeiboRequest *request = [self.sinaweibo requestWithURL:@"users/show.json" params:params httpMethod:@"GET" block:^(id result){
        [self loadUserDataFinish:result];
    }];
    
    [_requests addObject:request];
}
//用户数据请求成功
-(void)loadUserDataFinish:(NSMutableDictionary *)result
{
    UserModel *userModel = [[[UserModel alloc] initWithDataDic:result] autorelease];
    self.userInfo.userModel = userModel;
    [self refeshUI];
}

//请求微博列表
-(void)loadWeiboData
{
    if (self.userName.length == 0) {
        NSLog(@"error:用户为空");
        return;
    }
    
    //新浪接口改变了不能获取指定的人的微博，只能获取自己的微博列表
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.userName forKey:@"screen_name"];
    SinaWeiboRequest *request = [self.sinaweibo requestWithURL:@"statuses/user_timeline.json" params:params httpMethod:@"GET" block:^(id result){
        [self loadWeiboDataFinish:result];
    }];
    
    [_requests addObject:request];
}
//微博列表请求完成
-(void)loadWeiboDataFinish:(NSMutableDictionary *)result
{
    NSArray *statuses = [result objectForKey:@"statuses"];
    if (statuses != nil) {
        NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statuses.count];
        for (NSDictionary *dic in statuses) {
            WeiboModel *weiboModel = [[WeiboModel alloc] initWithDataDic:dic];
            [weibos addObject:weiboModel];
            [weiboModel autorelease];
        }
        
        self.tableView.data = weibos;
        
        [self.tableView reloadData];
    }else{
        //[super showHUDComplete:@"微博列表为空"];
    }
    
}

-(void)refeshUI
{
    [super hideHUD:YES afterDelay:1];
    self.tableView.hidden = NO;
    self.tableView.tableHeaderView = _userInfo;
}

//返回主页
-(void)goHome
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewEventDelegate
-(void)pullDown:(BaseTableView *)tableView
{
    NSLog(@"UserViewC下拉拉");
    //[self.tableView doneLoadingTableViewData];
    [self.tableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
}
-(void)pullUp:(BaseTableView *)tableView
{
    NSLog(@"UserViewC上啦啦");
    //[self.tableView stopMoreLoad:NO];
    [self.tableView performSelector:@selector(stopMoreLoad:) withObject:nil afterDelay:2.0];
}


@end
