//
//  CommentCell.m
//  WXWeibo
//
//  Created by 周城 on 14-4-29.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "CommentCell.h"
#import "RTLabel.h"
#import "CommentModel.h"
#import "UIImageView+WebCache.h"
#import "UIUtils.h"
#import "NSString+URLEncoding.h"
#import "BaseImageView.h"
#import "UserViewController.h"

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    //获取xib上的控件
    _userImageView = [(BaseImageView *)[self viewWithTag:1] retain];
    _nickLabel = [(UILabel *)[self viewWithTag:2] retain];
    _timeLabel = [(UILabel *)[self viewWithTag:3] retain];
    
    _contentLabel = [[RTLabel alloc] initWithFrame:CGRectMake(_nickLabel.left, _nickLabel.bottom + 5, 240, 25)];
    _contentLabel.font = [UIFont systemFontOfSize:13.0f];
    _contentLabel.delegate = self;
    //设置链接的颜色
    _contentLabel.linkAttributes = [NSDictionary dictionaryWithObject:@"#4595CB" forKey:@"color"];//三色值
    //设置链接高亮的颜色
    _contentLabel.selectedLinkAttributes = [NSDictionary dictionaryWithObject:@"darkGray" forKey:@"color"];
    [self.contentView addSubview:_contentLabel];
    [_contentLabel autorelease];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //头像
    _userImageView.frame = CGRectMake(5, 5, 40, 40);
    NSString *urlString = self.commentModel.user.profile_image_url;
    [_userImageView setImageWithURL:[NSURL URLWithString:urlString]];
    //设置圆角和边框
    _userImageView.layer.cornerRadius = 5;
    _userImageView.layer.masksToBounds = YES;
    _userImageView.backgroundColor = [UIColor clearColor];
    _userImageView.layer.borderWidth = 0.5;
    _userImageView.layer.borderColor = [UIColor grayColor].CGColor;
    
    //响应图片点击的回调函数
    __block CommentCell *this = self;//防止循环引用
    _userImageView.touchBlock = ^{
        //用户个人资料
        NSString *nickName = _commentModel.user.screen_name;
        UserViewController *userInfoViewCtrl = [[[UserViewController alloc] init] autorelease];
        userInfoViewCtrl.userName = nickName;
        //响应者链来获得Controller
        [this.viewController.navigationController pushViewController:userInfoViewCtrl animated:YES];
    };
    
    //昵称
    _nickLabel.text = self.commentModel.user.screen_name;
    //发布时间
    _timeLabel.text = [UIUtils fomateString:self.commentModel.created_at];
    
    //评论
    NSString *commentText = self.commentModel.text;
    commentText = [UIUtils parseLink:commentText];//解析替换超链接
    _contentLabel.text = commentText;
    _contentLabel.height = _contentLabel.optimumSize.height;
    
}

+(float)getCommentHeight:(CommentModel *)commentModel
{
    RTLabel *rt = [[RTLabel alloc] initWithFrame:CGRectMake(0, 0, 240, 0)];
    rt.font = [UIFont systemFontOfSize:13.0f];
    rt.text = commentModel.text;
    
    return rt.optimumSize.height + 5;
}

#pragma mark - RTLabelDelegate
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    //获取完整的url字符串 带端口号
    NSString *absoluteString = [url absoluteString];
    //获取不带http，端口 的主地址
    NSString *urlString = [url host];
    
    if ([absoluteString hasPrefix:@"user"]) {
        urlString = [urlString URLDecodedString];
        
        NSRange range;
        range.location = 0;
        range.length = 1;
        if ([[urlString substringWithRange:range] isEqualToString:@"@"]) {
            urlString =[urlString substringFromIndex:1];
        }

        NSLog(@"子视图用户:%@",urlString);
    }else if ([absoluteString hasPrefix:@"http"])
    {
        NSLog(@"子视图网址:%@",absoluteString);
    }else if ([absoluteString hasPrefix:@"topic"])
    {
        urlString = [urlString URLDecodedString];
        NSLog(@"子视图话题:%@",urlString);
    }

}


@end
