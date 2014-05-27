//
//  HomeViewController.h
//  WXWeibo
//  首页控制器

//  Created by 周城 on 14-5-6.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboTableView.h"
#import "ThemeImageView.h"

@protocol HomeViewControllerDelegate <NSObject>
@optional
-(void)didFinishpulldownData;
@end

@interface HomeViewController : BaseViewController<SinaWeiboRequestDelegate,UITableViewEventDelegate>{
    ThemeImageView *_barView;
}

@property(nonatomic,copy)NSString *topWeiboID;
@property(nonatomic,copy)NSString *lastWeiboID;

@property (retain, nonatomic)WeiboTableView *tableView;

@property(nonatomic,retain)NSMutableArray *weibos;

@property(nonatomic,assign)id<HomeViewControllerDelegate> homeViewControllerDelegate;

-(void)refreshWeibo;
-(void)loadWeiboData;

@end
