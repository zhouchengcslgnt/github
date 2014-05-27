//
//  DetailViewController.m
//  WXWeibo
//
//  Created by 周城 on 14-4-28.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "DetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "WeiboModel.h"
#import "WeiboView.h"
#import "CommentTableView.h"
#import "CommentModel.h"
#import "BaseImageView.h"
#import "UserViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)dealloc {
    [_tableView release];
    [_userImageView release];
    [_nickLabel release];
    [_userBarView release];
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
    [self _initView];
    [self loadData];
}

-(void)_initView
{
    //头视图
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    
    //设置圆角和边框
    self.userImageView.layer.cornerRadius = 5;
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.backgroundColor = [UIColor clearColor];
    self.userImageView.layer.borderWidth = 0.5;
    self.userImageView.layer.borderColor = [UIColor grayColor].CGColor;
    
    //加载图片
    NSString *userImageUrl = _weiboModel.user.profile_image_url;
    [self.userImageView setImageWithURL:[NSURL URLWithString:userImageUrl]];
    //防止循环引用
    __block DetailViewController *this = self;
    self.userImageView.touchBlock = ^{
        //用户个人资料
        NSString *nickName = _weiboModel.user.screen_name;
        UserViewController *userInfoViewCtrl = [[[UserViewController alloc] init] autorelease];
        userInfoViewCtrl.userName = nickName;
        //响应者链来获得Controller
        [this.navigationController pushViewController:userInfoViewCtrl animated:YES];
    };
    
    //微博昵称
    self.nickLabel.text = _weiboModel.user.screen_name;
    
    [tableHeaderView addSubview:_userBarView];
    tableHeaderView.height += 60;
    
    //创建微博视图
    _weiboView.isDetail = YES;
    float h = [WeiboView getWeiboViewHeight:_weiboModel isRepost:NO isDetail:YES];
    _weiboView = [[WeiboView alloc] initWithFrame:CGRectMake(10, _userBarView.bottom + 5, ScreenWidth -20, h)];
    _weiboView.isDetail = YES;
    _weiboView.weiboModel = _weiboModel;
    
    [tableHeaderView addSubview:_weiboView];
    tableHeaderView.height += h;
    
    //加到tableView的头视图
    self.tableView.tableHeaderView = tableHeaderView;
    [tableHeaderView release];
    
    _tableView.eventDelegate = self;
}

-(void)loadData
{
    NSString *weiboID = [_weiboModel.weiboId stringValue];
     NSLog(@"weiboID:%@",weiboID);
    if (weiboID.length == 0) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:weiboID forKey:@"id"];
    
    [self.sinaweibo requestWithURL:@"comments/show.json" params:params httpMethod:@"GET" block:^(NSDictionary *ret){
        [self loadDataFinish:ret];
        
    }];
}

-(void)loadDataFinish:(NSDictionary *)ret
{
    NSArray *array = [ret objectForKey:@"comments"];
    NSMutableArray *comments = [NSMutableArray arrayWithCapacity:array.count];
    NSLog(@"array.count:%d",array.count);
    for (NSDictionary *dic in array) {
        CommentModel *commentModel = [[CommentModel alloc] initWithDataDic:dic];
        [comments addObject:commentModel];
        [commentModel release];
    }
    
    self.tableView.data = comments;
    self.tableView.commentDic = ret;
    [self.tableView reloadData];
}

#pragma mark - UITableViewEventDelegate
-(void)pullDown:(BaseTableView *)tableView
{
    NSLog(@"下拉拉");
    //[self.tableView doneLoadingTableViewData];
    [self.tableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
}
-(void)pullUp:(BaseTableView *)tableView
{
    NSLog(@"上啦啦");
    //[self.tableView stopMoreLoad:NO];
    [self.tableView performSelector:@selector(stopMoreLoad:) withObject:nil afterDelay:2.0];
}

-(void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
