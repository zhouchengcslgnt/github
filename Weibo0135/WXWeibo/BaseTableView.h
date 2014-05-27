//
//  BaseTableView.h
//  WXWeibo
//
//  Created by 周城 on 14-4-26.
//  Copyright (c) 2014年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

//协议定义
@class BaseTableView;

@protocol UITableViewEventDelegate <NSObject>
@optional
-(void)pullDown:(BaseTableView *)tableView;
-(void)pullUp:(BaseTableView *)tableView;
-(void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface BaseTableView : UITableView <EGORefreshTableHeaderDelegate,UITableViewDelegate,UITableViewDataSource>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    UIButton *_moreButton;
    UIActivityIndicatorView *_activityView;
    BOOL _isLoad;
}

@property(nonatomic,assign)BOOL refreshHearder;//是否需要下拉
@property(nonatomic,retain)NSArray *data;//为TableView提供数据
@property(nonatomic,assign)id<UITableViewEventDelegate> eventDelegate;

-(void)doneLoadingTableViewData;

//扩展:下拉显示加载
-(void)initLoading;

-(void)stopMoreLoad:(BOOL)finished;

@end
