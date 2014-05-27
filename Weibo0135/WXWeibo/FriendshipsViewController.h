//
//  FriendshipsViewController.h
//  WXWeibo
//
//  Created by 周城 on 14-5-22.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "BaseViewController.h"

@class FriendShipsTableView;
@interface FriendshipsViewController : BaseViewController

@property(nonatomic,copy)NSString *userID;
@property(nonatomic,retain)NSMutableArray *data;

@property (retain, nonatomic) IBOutlet FriendShipsTableView *tableView;

@end
