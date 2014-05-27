//
//  BaseTableView.m
//  WXWeibo
//
//  Created by 周城 on 14-4-26.
//  Copyright (c) 2014年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseTableView.h"

@implementation BaseTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style] ;
    if (self) {
        // Initialization code
        [self _initView];
    }
    return self;
}

//使用xib创建
-(void)awakeFromNib
{
    [self _initView];
}

-(void)_initView
{
    //创建下拉的试图
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    _refreshHeaderView.backgroundColor = [UIColor clearColor];//去掉背景颜色
    self.dataSource = self;
    self.delegate = self;
    self.refreshHearder = YES;
    
    //创建上拉的试图，是个按钮
    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreButton retain];
    _moreButton.backgroundColor = [UIColor clearColor];
    _moreButton.frame = CGRectMake(0, 0, ScreenWidth, 30);
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_moreButton setTitle:NSLocalizedString(@"上拉加载更多...", @"Down load more") forState:UIControlStateNormal];
    [_moreButton setTitleColor:TEXT_COLOR forState:UIControlStateNormal];//设置颜色
    [_moreButton addTarget:self action:@selector(loadMoreAction) forControlEvents:UIControlEventTouchUpInside];
    
    //创建等待的图标控件
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityView.frame = CGRectMake(100, 8, 15, 15);
    [_activityView stopAnimating];
    [_moreButton addSubview:_activityView];
    [_activityView release];
    
    self.tableFooterView = _moreButton;//把尾试图加上button
}

-(void)setRefreshHearder:(BOOL)refreshHearder
{
    _refreshHearder = refreshHearder;
    if (_refreshHearder) {
        [self addSubview:_refreshHeaderView];
    }else{
        if ([_refreshHeaderView subviews]) {
            [_refreshHeaderView removeFromSuperview];
        }
    }
}

//上拉的按钮点击 调用的方法
-(void)loadMoreAction
{
    if ([self.eventDelegate respondsToSelector:@selector(pullUp:)]) {
        [_eventDelegate pullUp:self];
        [self _startMoreLoad];
    }
}

//开始加载
-(void)_startMoreLoad
{
    _moreButton.enabled = NO;
    [_moreButton setTitle:@"正在加载..." forState:UIControlStateNormal];
    [_activityView startAnimating];
}

//停止加载
-(void)stopMoreLoad:(BOOL)finished
{
    if (finished) {
        [_moreButton setTitle:@"已全部加载" forState:UIControlStateNormal];
         _moreButton.enabled = NO;
    }else{
        [_moreButton setTitle:NSLocalizedString(@"上拉加载更多...", @"Down load more") forState:UIControlStateNormal];
         _moreButton.enabled = YES;
    }
    [_activityView stopAnimating];
    _isLoad = NO;
   
}


//扩展:下拉显示加载
-(void)initLoading
{
    [_refreshHeaderView initLoading:self];
}


#pragma mark UItableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.eventDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.eventDelegate tableView:self didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - 下拉相关的方法
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods
//当滑动时，实时调用此方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    float offset = scrollView.contentOffset.y;
    float contentHeight = scrollView.contentSize.height;
    float height = scrollView.height;

//    NSLog(@"offset:%f",offset);
//    NSLog(@"cHeight:%f",contentHeight);
//    NSLog(@"height:%f",height);
    
    if (offset + height > contentHeight + 30 && offset > 0) {
        if (_isLoad == NO) {
            [_moreButton setTitle:@"松手加载..." forState:UIControlStateNormal];
        }
    }else{
        if (_isLoad == NO) {
            [_moreButton setTitle:NSLocalizedString(@"上拉加载更多...", @"Down load more") forState:UIControlStateNormal];
        }
    }
    
}
//手指停止拖拽是调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
	float offset = scrollView.contentOffset.y;
    float contentHeight = scrollView.contentSize.height;
    float height = scrollView.height;
    
    if (offset + height > contentHeight + 30 && offset > 0) {
        if ([self.eventDelegate respondsToSelector:@selector(pullUp:)]) {
            _isLoad = YES;
            [_eventDelegate pullUp:self];
            [self _startMoreLoad];
        }
    }
    
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
//下拉到一定距离，手指放开时调用
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
    //显示下拉
	[self reloadTableViewDataSource];
    
    //判断是否存在这个方法
	if ([self.eventDelegate respondsToSelector:@selector(pullDown:)]) {
        [self.eventDelegate pullDown:self];
    }
    
    //停止加载，弹回下拉，这边模拟2秒
    //	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading;
	
}

//取得下拉刷新的时间
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date];
}



@end
