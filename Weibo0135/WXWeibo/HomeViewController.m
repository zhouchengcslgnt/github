//
//  HomeViewController.m
//  WXWeibo
//
//  Created by 周城 on 14-5-6.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "HomeViewController.h"
#import "WeiboModel.h"
#import "UIFactory.h"
#import <AudioToolbox/AudioToolbox.h>
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "DDMenuController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)dealloc {
    [_tableView release];
    [_weibos release];
    [_topWeiboID release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"微博";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //绑定按钮
    UIBarButtonItem *bindItem = [[UIBarButtonItem alloc] initWithTitle:@"绑定账号" style:UIBarButtonItemStyleBordered target:self action:@selector(bindAction:)];
    self.navigationItem.rightBarButtonItem = [bindItem autorelease];
    
    //注销按钮
    UIBarButtonItem *logoutItem = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutAction:)];
    self.navigationItem.leftBarButtonItem = [logoutItem autorelease];
    
    _tableView = [[WeiboTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-49-44) style:UITableViewStylePlain];
    _tableView.eventDelegate = self;
    
    [self.view addSubview:_tableView];
    
    //判断是否认证
    if (self.sinaweibo.isAuthValid) {
        //加载微博列表数据
        [self loadWeiboData];
    }else{
        [self.sinaweibo logIn];
    }
}

//view即将可见是调用
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //开启左滑，右滑菜单
    [[self appDelegate].menuCtrl setEnableGesture:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //禁用左右滑
    [[self appDelegate].menuCtrl setEnableGesture:NO];
    
}

//显示新微博数量
-(void)showNewWeiboCount:(int)count
{
    if (_barView == nil) {
        //从一个点拉伸
        _barView = [UIFactory createImageView:@"timeline_new_status_background.png"];
        _barView.image = [_barView.image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        _barView.topCapHeight = 5;
        _barView.leftCapWidth = 5;
        [_barView retain];
        _barView.frame = CGRectMake(5, -40, ScreenWidth-10, 40);//隐藏
        _barView.alpha = 0.8;
        [self.view addSubview:_barView];
        [_barView autorelease];
        
        //创建一个label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.tag = 1;
        label.font = [UIFont systemFontOfSize:17.0f];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        [_barView addSubview:label];
        [label autorelease];
    }
    
    
    UILabel *label = (UILabel *)[_barView viewWithTag:1];
    if (count > 0) {
        label.text = [NSString stringWithFormat:@"%d条新微博",count];
    }
    else{
        label.text = @"没有新的微博";
    }
    [label sizeToFit];
    label.origin = CGPointMake((_barView.width-label.width)/2, (_barView.height - label.height)/2);
    
    [UIView animateWithDuration:0.6 animations:^{
        _barView.top = 1;//显示，0.6秒的动画
    } completion:^(BOOL finish){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:0.5];//延时一秒
        [UIView setAnimationDuration:0.6];//0.6秒的动画
        _barView.top = -40;//隐藏
        [UIView commitAnimations];
    }];
    
    //设置声音
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((CFURLRef)url, &soundID);
    AudioServicesPlaySystemSound(soundID);//播放声音
    
    
}

//下拉加载数据实现
-(void)pulldownData
{
    NSLog(@"请求网络数据");
    if (self.topWeiboID.length == 0) {
        NSLog(@"微博ID为空");
        return;
    }
    /*
     since_id:若指定此参数，则返回ID比since_id大的微博，默认为0
     count：单页返回的记录数，最大100，默认为20.
     */
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"20",@"count",self.topWeiboID,@"since_id",nil];
    [self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
                            params:params
                        httpMethod:@"GET"
                             block:^(id result){
                                 [self pullDownDataFinish:result];
                             }];

}

//下拉刷新完成返回时调用的方法
-(void)pullDownDataFinish:(id) result
{
    //result是个JSON格式的数组
    NSArray *statues = [result objectForKey:@"statuses"];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:statues.count];
    for (NSDictionary *statuesDic in statues) {
        //将JSON格式的数据转换成model的属性
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
        [array addObject:weibo];
        [weibo release];
    }
    //取最新的weiboID
    if (array.count > 0) {
        WeiboModel *topWeibo = [array objectAtIndex:0];
        self.topWeiboID = [topWeibo.weiboId stringValue];
    }
    
    //把原数据追加到后面
    [array addObjectsFromArray:self.weibos];
    //保存下
    self.weibos = array;
    //赋给data
    self.tableView.data = array;

    //刷新tableView
    [self.tableView reloadData];
    //弹回下拉
    [self.tableView doneLoadingTableViewData];
    
    //提示更新的微博的数目
    int updateCount = [statues count];
    NSLog(@"更新的微博数目：%d",updateCount);
    //显示更新的微博项目
    [self showNewWeiboCount:updateCount];
    
    //调用delegate 隐藏未读
    [self.homeViewControllerDelegate didFinishpulldownData];

}

//上拉加载数据实现
-(void)pullUpData
{
    NSLog(@"请求网络数据");
    if (self.lastWeiboID.length == 0) {
        NSLog(@"微博ID为空");
        return;
    }
    /*
     max_id:若指定此参数，则返回ID比since_id大的微博，默认为0
     count：单页返回的记录数，最大100，默认为10.
     */
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"11",@"count",self.lastWeiboID,@"max_id",nil];
    [self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
                            params:params
                        httpMethod:@"GET"
                             block:^(id result){
                                 [self pullUpDataFinish:result];
                             }];
    
}

//上拉刷新完成返回时调用的方法
-(void)pullUpDataFinish:(id) result
{
    //result是个JSON格式的数组
    NSArray *statues = [result objectForKey:@"statuses"];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:statues.count];
    for (NSDictionary *statuesDic in statues) {
        //将JSON格式的数据转换成model的属性
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
        [array addObject:weibo];
        [weibo release];
    }
    
    //把加载的数据追加到原数据后面
    [array removeObjectAtIndex:0];//去掉第一条重复的
    [self.weibos addObjectsFromArray:array];

    //赋给data
    self.tableView.data = self.weibos;
    
    //刷新tableView
    [self.tableView reloadData];
    
    //取最小的weiboID
    if (array.count > 0) {
        WeiboModel *lastWeibo = [array lastObject];
        self.lastWeiboID = [lastWeibo.weiboId stringValue];
        //停止加载
        [self.tableView stopMoreLoad:NO];
    }else{
        //停止加载
        [self.tableView stopMoreLoad:YES];
    }
    
    
    //提示更新的微博的数目
    int updateCount = [statues count] - 1;
    //显示更新的微博项目
    [self showNewWeiboCount:updateCount];
}


#pragma mark - UITableViewEventDelegate
//下拉刷新数据
-(void)pullDown:(BaseTableView *)tableView
{
    [self pulldownData];
    //[tableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
}

//上拉
-(void)pullUp:(BaseTableView *)tableView
{
    [self pullUpData];
    
}
//点击某列
-(void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选中cell");
}


#pragma mark - load Data
- (void)loadWeiboData {
    //显示加载提示
    [super showHUD:@"正在加载" isBim:NO];
    //tableView隐藏
    _tableView.hidden = YES;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"20" forKey:@"count"];
    [self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
                            params:params
                        httpMethod:@"GET"
                          delegate:self];
}

-(void)refreshWeibo
{
    //使UI下拉
    [self.tableView initLoading];
    //刷新数据
    [self pulldownData];
}

#pragma mark - SinaWeiboRequest delegate
//网络加载失败
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"网络加载失败:%@",error);
}

//网络加载完成
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    //result是个JSON格式的数组
    NSArray *statues = [result objectForKey:@"statuses"];
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statues.count];
    for (NSDictionary *statuesDic in statues) {
        //将JSON格式的数据转换成model的属性
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
        [weibos addObject:weibo];
        [weibo release];
    }
    
    self.tableView.data = weibos;
    self.weibos = weibos;//保存下
    
    //取最新的weiboID
    if (weibos.count > 0) {
        WeiboModel *topWeibo = [weibos objectAtIndex:0];
        self.topWeiboID = [topWeibo.weiboId stringValue];
        
        WeiboModel *lastWeibo = [weibos lastObject];
        self.lastWeiboID = [lastWeibo.weiboId stringValue];
    }
    
    //刷新tableView
    [self.tableView reloadData];
    
    //移除等待的画面
    [super hideHUD:YES];
    _tableView.hidden = NO;
    
    //显示加载完成，他会自动移除等待画面
    //[super showHUDComplete:@"加载完成"];
}



#pragma mark - actions
- (void)bindAction:(UIBarButtonItem *)buttonItem {
    [self.sinaweibo logIn];
}

- (void)logoutAction:(UIBarButtonItem *)buttonItem {
    [self.sinaweibo logOut];
}

#pragma mark - Memery Manager
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    
}


@end
