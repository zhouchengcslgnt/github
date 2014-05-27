//
//  DetailViewController.h
//  WXWeibo
//
//  Created by 周城 on 14-4-28.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "BaseViewController.h"
#import "CommentTableView.h"

@class WeiboView;
@class WeiboModel;
@class BaseImageView;
@interface DetailViewController : BaseViewController<UITableViewEventDelegate>{
    WeiboView *_weiboView;
}

@property(nonatomic,retain)WeiboModel *weiboModel;

@property (retain, nonatomic) IBOutlet CommentTableView *tableView;

@property (retain, nonatomic) IBOutlet BaseImageView *userImageView;

@property (retain, nonatomic) IBOutlet UILabel *nickLabel;

@property (retain, nonatomic) IBOutlet UIView *userBarView;

@end
