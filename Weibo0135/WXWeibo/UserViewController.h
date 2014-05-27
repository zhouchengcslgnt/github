//
//  UserViewController.h
//  WXWeibo
//
//  Created by 周城 on 14-5-4.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboTableView.h"

@class UserInfoView;
@interface UserViewController : BaseViewController<UITableViewEventDelegate>

@property(nonatomic,copy)NSString *userName;

@property(nonatomic,retain)UserInfoView *userInfo;

@property (retain, nonatomic) IBOutlet WeiboTableView *tableView;

@end
