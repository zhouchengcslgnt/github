//
//  WeiboAnnotation.h
//  WXWeibo
//
//  Created by 周城 on 14-5-20.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "WeiboModel.h"

@interface WeiboAnnotation : NSObject<MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

@property(nonatomic,retain)WeiboModel *weiboModel;

-(id)initWithWeibo:(WeiboModel *)weibo;



@end
