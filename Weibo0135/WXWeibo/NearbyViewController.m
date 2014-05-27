//
//  NearbyViewController.m
//  WXWeibo
//
//  Created by 周城 on 14-5-7.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "NearbyViewController.h"
#import "UIImageView+WebCache.h"
#import "WebDataService.h"

@interface NearbyViewController ()

@end

@implementation NearbyViewController

- (void)dealloc
{
    [_tableView release];
    Block_release(_selectBlock);
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isCacelButton = YES;
        self.isBackButton = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我在这里";
    
    self.tableView.hidden = YES;
    [self showHUD:@"正在加载数据..." isBim:NO];
    
    //请求接口数据，先获取位置
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [locationManager startUpdatingLocation];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        //创建列表 UITableViewCellStyleSubtitle
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify] autorelease];
    }
    
    //处理数据
    NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
    NSString *title = [dic objectForKey:@"title"];
    NSString *address = [dic objectForKey:@"address"];
    NSString *icon = [dic objectForKey:@"icon"];
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = address;
    [cell.imageView setImageWithURL:[NSURL URLWithString:icon]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
    self.selectBlock(dic);
    [self cancleAction];
    
}

#pragma mark - CLLocationManagerDelegate
//定位成功调用的
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_6, __MAC_NA, __IPHONE_2_0, __IPHONE_6_0)
{
    [manager stopUpdatingLocation];//停止定位
    //获取经纬度
    float longitude = newLocation.coordinate.longitude;
    float latitude = newLocation.coordinate.latitude;
    NSString *longitudeString = [NSString stringWithFormat:@"%f",longitude];
    NSString *latitudeString = [NSString stringWithFormat:@"%f",latitude];
    //组织参数
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:longitudeString,@"long",latitudeString,@"lat", nil];
    
//    //调用新浪接口
//    [self.sinaweibo requestWithURL:@"place/nearby/pois.json" params:params httpMethod:@"GET" block:^(id result){
//        //调用完成返回后 执行方法
//        [self loadNearbyDataFinish:result];
//    }];
    
    //调用自己封装的AS网络请求
    [WebDataService requestWithURL:@"place/nearby/pois.json" params:params httpMethod:@"GET" completeBlock:^(id result) {
        //调用完成返回后 执行方法
        [self loadNearbyDataFinish:result];
    }];
    
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"loacationError%@",error);
}

//返回位置后 加载位置
-(void)loadNearbyDataFinish:(NSDictionary *)result
{
    NSArray *pois = [result objectForKey:@"pois"];
    self.data = pois;
    [self refreshUI];
}

//刷新列表
-(void)refreshUI
{
    self.tableView.hidden = NO;
    [self hideHUD:YES];
    [self.tableView reloadData];
}

@end
