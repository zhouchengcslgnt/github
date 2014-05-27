//
//  WeiboAnnotationView.h
//  WXWeibo
//
//  Created by 周城 on 14-5-20.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface WeiboAnnotationView : MKAnnotationView{
    UIImageView *_userImage;//用户头像
    UIImageView *_weiboImage;//微博图片视图
    UILabel *_textLabel;//微博内容
}

@end
