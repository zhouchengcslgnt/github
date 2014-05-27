//
//  WeiboCell.m
//  WXWeibo
//
//  Created by 周城 on 14-5-6.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "WeiboCell.h"
#import <QuartzCore/QuartzCore.h>
#import "WeiboView.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
#import "RegexKitLite.h"
#import "UIFactory.h"
#import "UIUtils.h"
#import "BaseImageView.h"
#import "UserViewController.h"

@implementation WeiboCell

-(void)dealloc
{
    [super dealloc];
    [_weiboView release];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

//初始化子视图
- (void)_initView {
    //用户头像
    _userImage = [[BaseImageView alloc] initWithFrame:CGRectZero];
    _userImage.backgroundColor = [UIColor clearColor];
    _userImage.layer.cornerRadius = 5;  //圆弧半径
    _userImage.layer.borderWidth = .5;
    _userImage.layer.borderColor = [UIColor grayColor].CGColor;
    _userImage.layer.masksToBounds = YES;
    [self.contentView addSubview:_userImage];
    [_userImage autorelease];
    
    //昵称
    _nickLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _nickLabel.backgroundColor = [UIColor clearColor];
    _nickLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:_nickLabel];
    [_nickLabel autorelease];
    
    //转发数
    _repostCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _repostCountLabel.font = [UIFont systemFontOfSize:12.0];
    _repostCountLabel.backgroundColor = [UIColor clearColor];
    _repostCountLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_repostCountLabel];
    [_repostCountLabel autorelease];
    
    //回复数
    _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _commentLabel.font = [UIFont systemFontOfSize:12.0];
    _commentLabel.backgroundColor = [UIColor clearColor];
    _commentLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_commentLabel];
    [_commentLabel autorelease];
    
    //微博来源
    _sourceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _sourceLabel.font = [UIFont systemFontOfSize:12.0];
    _sourceLabel.backgroundColor = [UIColor clearColor];
    _sourceLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_sourceLabel];
    [_sourceLabel autorelease];
    
    //发布时间
    _createLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _createLabel.font = [UIFont systemFontOfSize:12.0];
    _createLabel.backgroundColor = [UIColor clearColor];
    _createLabel.textColor = [UIColor blueColor];
    [self.contentView addSubview:_createLabel];
    [_createLabel autorelease];
    
    //微博视图
    _weiboView = [[WeiboView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_weiboView];
    
    
    //设置选中的背景
   // UIView *selectedBackgroundView = [UIFactory createImageView:@"navigationbar_background.png"];
    UIImageView *selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigationbar_background.png"]];
    self.selectedBackgroundView = selectedBackgroundView;
    [selectedBackgroundView release];
}

//加载内容
- (void)layoutSubviews {
    [super layoutSubviews];
    
    //-----------用户头像视图_userImage--------
    _userImage.frame = CGRectMake(5, 5, 35, 35);
    NSString *userImageUrl = _weiboModel.user.profile_image_url;
    [_userImage setImageWithURL:[NSURL URLWithString:userImageUrl]];
    
    //防止循环引用
    __block WeiboCell *this = self;
    _userImage.touchBlock = ^{
        //用户个人资料
        NSString *nickName = _weiboModel.user.screen_name;
        UserViewController *userInfoViewCtrl = [[[UserViewController alloc] init] autorelease];
        userInfoViewCtrl.userName = nickName;
        //响应者链来获得Controller
        [this.viewController.navigationController pushViewController:userInfoViewCtrl animated:YES];
    };
    
    //昵称_nickLabel
    _nickLabel.frame = CGRectMake(50, 5, 200, 20);
    _nickLabel.text = _weiboModel.user.screen_name;
    
//    //转发数
//    _repostCountLabel.frame = CGRectMake(_nickLabel.right+5, 5, 50, 20);
//    _repostCountLabel.text = [NSString stringWithFormat:@"%@",_weiboModel.repostsCount];

    
    //微博视图_weiboView
    _weiboView.weiboModel = _weiboModel;
    
    //获取微博视图的高度
    float h = [WeiboView getWeiboViewHeight:_weiboModel isRepost:NO isDetail:NO];
    _weiboView.frame = CGRectMake(50, _nickLabel.bottom+10, kWeibo_Width_List, h);
    
    
    //发布时间
    _createLabel.frame = CGRectMake(50, _weiboView.top + h, 100, 20);
    //日期转换
    NSString *createDatestring = _weiboModel.createDate;
    NSDate *date = [UIUtils dateFromFomate:createDatestring formate:@"E M D HH:mm:ss Z yyyy"];
    NSString *dateString = [UIUtils stringFromFomate:date formate:@"MM-dd HH:mm:ss"];
    _createLabel.text = dateString;
    [_createLabel sizeToFit];//宽度自动适应
    
    //来源
    NSString *source = [self parseSource:_weiboModel.source];
    if (source == nil) {
        source = @"网页";
    }
    _sourceLabel.frame = CGRectMake(_createLabel.left + _createLabel.width + 10, _weiboView.top+h, 200, 20);
    _sourceLabel.text = [NSString stringWithFormat:@"来自:%@",source];
    [_sourceLabel sizeToFit];
    
}

//通过正则表达式，获取 字符 微博来源
-(NSString *)parseSource:(NSString *)source
{
    //"<a href=\"http://app.weibo.com/t/feed/9ksdit\" rel=\"nofollow\">iPhone客户端</a>"
    NSString *regex = @">\\w+<";
    //获取 >iPhone客户端<
    NSArray *array = [source componentsMatchedByRegex:regex];
    if (array.count > 0 ) {
        NSString *ret = [array objectAtIndex:0];
        NSRange range;
        range.location = 1;
        range.length = ret.length - 2;
        NSString *resultstring = [ret substringWithRange:range];//截取字符
        return resultstring;
    }
    return nil;
}



@end
