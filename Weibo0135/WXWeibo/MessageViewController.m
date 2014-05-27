//
//  MessageViewController.m
//  WXWeibo
//
//  Created by wei.chen on 13-1-21.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "MessageViewController.h"
#import "FaceView.h"
#import "FaceScrollView.h"
#import "UIFactory.h"
#import "WebDataService.h"
#import "WeiboModel.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"消息";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self loadAtWeiboData];
}

-(void)initView
{
    _tableView = [[WeiboTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-49-44) style:UITableViewStylePlain];
    _tableView.eventDelegate = self;
    [self.view addSubview:_tableView];
    
    //
    NSArray *messageButtons = [NSArray arrayWithObjects:
                               @"navigationbar_mentions.png",
                               @"navigationbar_comments.png",
                               @"navigationbar_messages.png",
                               @"navigationbar_notice.png",nil];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    for (int i = 0; i<messageButtons.count; i++) {
        NSString *imageName = [messageButtons objectAtIndex:i];
        UIButton *button = [UIFactory createButton:imageName highlighted:imageName];
        button.showsTouchWhenHighlighted = YES;
        button.frame = CGRectMake(50*i + 10, 10, 22, 22);
        [button addTarget:self action:@selector(messageAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100+i;
        [titleView addSubview:button];
    }
    self.navigationItem.titleView = titleView;
    
}

#pragma mark - Action
-(void)messageAction:(UIButton *)button
{
    int tag = button.tag;
    if (tag == 100) {
        
    }else if (tag == 101){
        
    }
}

-(void)loadAtWeiboData
{
    [self showHUD:@"正在加载..." isBim:NO];
    _tableView.hidden = YES;
    
    [WebDataService requestWithURL:@"statuses/mentions.json" params:nil httpMethod:@"GET" completeBlock:^(id result) {
        [self loadAtWeiboDataFinish:result];
    }];
}

-(void)loadAtWeiboDataFinish:(NSDictionary *)result
{
    //result是个JSON格式的数组
    NSArray *statues = [result objectForKey:@"statuses"];
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statues.count];
    for (NSDictionary *statuesDic in statues) {
        //将JSON格式的数据转换成model的属性
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
        [weibos addObject:weibo];
        [weibo release];
    }
    
    _tableView.hidden = NO;
    [self hideHUD:YES];
    _tableView.data = weibos;
    [_tableView reloadData];
}

#pragma mark - UITableViewEventDelegate
-(void)pullDown:(BaseTableView *)tableView
{
    
}

-(void)pullUp:(BaseTableView *)tableView
{
    
}

@end
