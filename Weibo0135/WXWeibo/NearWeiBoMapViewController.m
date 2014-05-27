//
//  NearWeiBoMapViewController.m
//  WXWeibo
//
//  Created by 周城 on 14-5-20.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "NearWeiBoMapViewController.h"
#import "WebDataService.h"
#import "WeiboModel.h"
#import "WeiboAnnotation.h"
#import "WeiboAnnotationView.h"

@interface NearWeiBoMapViewController ()

@end

@implementation NearWeiBoMapViewController

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
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
}

-(void)loadNearWeiboData:(NSString *)lon latitude:(NSString *)lat
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:lon,@"long",lat,@"lat",nil];
    [WebDataService requestWithURL:@"place/nearby_timeline.json" params:params httpMethod:@"GET" completeBlock:^(id result) {
        [self loadDataFinish:result];
    }];
}

-(void)loadDataFinish:(NSDictionary *)result
{
    NSArray *statues = [result objectForKey:@"statuses"];
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statues.count];
    for (NSDictionary *statuesDic in statues) {
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
        [weibos addObject:weibo];
        [weibo release];
        
        //创建Anatation对象，添加到地图上去
        WeiboAnnotation *weiboAnnotation = [[WeiboAnnotation alloc] initWithWeibo:weibo];
        [self.mapView addAnnotation:weiboAnnotation];
        [weiboAnnotation release];
    }
}

#pragma mark - CLLocationManagerDelegate
//定位 一直运行的
- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations
{
    NSLog(@"locations:%@",[locations objectAtIndex:0]);
    CLLocation *cllocation = (CLLocation *)[locations objectAtIndex:0];
    
    
    CLLocationCoordinate2D coordinate = cllocation.coordinate;
    
	MKCoordinateSpan span = {0.1,0.1};
    MKCoordinateRegion regin = {coordinate,span};
    [self.mapView setRegion:regin animated:YES];//定位，在地图上显示你的位置
    
    if (self.data == nil) {
        NSString *lon = [NSString stringWithFormat:@"%f",coordinate.longitude];
        NSString *lat = [NSString stringWithFormat:@"%f",coordinate.latitude];
        [self loadNearWeiboData:lon latitude:lat];
    }
}

#pragma  mark - MKMapViewDelegate
//Delegate 在xib已经设置
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *identify = @"WeiboAnnotationView";
    WeiboAnnotationView *annotationView = (WeiboAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identify];
    if (annotationView == nil) {
        annotationView = [[[WeiboAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identify] autorelease];
    }
    
    return annotationView;

}

- (void)dealloc {
    [_mapView release];
    [super dealloc];
}
@end
