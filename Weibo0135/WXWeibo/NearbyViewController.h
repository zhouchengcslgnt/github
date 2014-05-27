//
//  NearbyViewController.h
//  WXWeibo
//
//  Created by 周城 on 14-5-7.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>

typedef void(^SelectDoneBlock)(NSDictionary *);

@interface NearbyViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,retain)NSArray *data;

@property(nonatomic,copy)SelectDoneBlock selectBlock;


@end
