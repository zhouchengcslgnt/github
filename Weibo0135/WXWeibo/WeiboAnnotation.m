//
//  WeiboAnnotation.m
//  WXWeibo
//
//  Created by 周城 on 14-5-20.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "WeiboAnnotation.h"

@implementation WeiboAnnotation

-(id)initWithWeibo:(WeiboModel *)weibo
{
    self = [super init];
    if (self != nil) {
        self.weiboModel = weibo;
        
        
    }
    
    return self;
}

-(void)setWeiboModel:(WeiboModel *)weiboModel
{
    if (_weiboModel != weiboModel) {
        [_weiboModel release];
        _weiboModel = weiboModel;
        [_weiboModel retain];
    }
    
    //null -- NSNull
    NSDictionary *geo = weiboModel.geo;
    if ([geo isKindOfClass:[NSDictionary class]]) {
       NSArray *coord = [geo objectForKey:@"coordinates"];
        if (coord.count == 2) {
            float lat = [[coord objectAtIndex:0] floatValue];
            float lon = [[coord objectAtIndex:1] floatValue];
            _coordinate = CLLocationCoordinate2DMake(lat, lon);
        }
    }
}

@end
