//
//  CommentModel.h
//  WXWeibo
//
//  Created by 周城 on 14-4-29.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "WXBaseModel.h"
#import "UserModel.h"
#import "WeiboModel.h"

/*
 created_at
 id
 text
 source
 user
 mid
 idstr
 status
 */

@interface CommentModel : WXBaseModel

@property(nonatomic,copy)NSString *created_at;
@property(nonatomic,retain)NSNumber *id;
@property(nonatomic,copy)NSString *text;
@property(nonatomic,copy)NSString *source;
@property(nonatomic,retain)UserModel *user;
@property(nonatomic,copy)NSString *mid;
@property(nonatomic,copy)NSString *idstr;
@property(nonatomic,retain)WeiboModel *weibo;

@end
