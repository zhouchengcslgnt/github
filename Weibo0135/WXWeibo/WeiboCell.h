//
//  WeiboCell.h
//  WXWeibo
//  自定义微博cell
//  Created by 周城 on 14-5-6.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeiboModel;
@class WeiboView;
@class BaseImageView;
@interface WeiboCell : UITableViewCell {
    BaseImageView     *_userImage;    //用户头像视图
    UILabel         *_nickLabel;    //昵称
    UILabel         *_repostCountLabel; //转发数
    UILabel         *_commentLabel;     //回复数
    UILabel         *_sourceLabel;      //发布来源
    UILabel         *_createLabel;      //发布时间
}

//微博数据模型对象
@property(nonatomic,retain)WeiboModel *weiboModel;
//微博视图
@property(nonatomic,retain)WeiboView *weiboView;

@end
