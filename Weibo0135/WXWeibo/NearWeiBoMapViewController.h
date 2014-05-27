//
//  NearWeiBoMapViewController.h
//  WXWeibo
//
//  Created by 周城 on 14-5-20.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface NearWeiBoMapViewController : BaseViewController<CLLocationManagerDelegate,MKMapViewDelegate>

@property(nonatomic,retain)NSArray *data;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;

@end
