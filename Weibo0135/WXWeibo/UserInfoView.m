//
//  UserInfoView.m
//  WXWeibo
//
//  Created by 周城 on 14-5-4.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "UserInfoView.h"
#import "UIImageView+WebCache.h"
#import "UserModel.h"
#import "RectButton.h"
#import "FriendshipsViewController.h"

@implementation UserInfoView

- (void)dealloc {
    [_userImage release];
    [_nameLabel release];
    [_addressLabel release];
    [_infoLabel release];
    [_attButton release];
    [_fansButton release];
    [_countLabel release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //获取XIB的view UIView不能拥有自身的XIB 所以要用这个方法
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoView" owner:self options:nil] lastObject];
        
        [self addSubview:view];
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //用户头像
    NSString *urlString = self.userModel.avatar_large;
    [self.userImage setImageWithURL:[NSURL URLWithString:urlString]];
    //设置圆角和边框
    self.userImage.layer.cornerRadius = 5;
    self.userImage.layer.masksToBounds = YES;
    self.userImage.backgroundColor = [UIColor clearColor];
    self.userImage.layer.borderWidth = 0.5;
    self.userImage.layer.borderColor = [UIColor grayColor].CGColor;
    
    //用户昵称
    self.nameLabel.text = self.userModel.screen_name;
    
    //性别，m：男、f：女、n：未知
    NSString *sexName;
    if([self.userModel.gender isEqualToString:@"m"]){
        sexName = @"男";
        
    }else if([self.userModel.gender isEqualToString:@"f"]){
        sexName = @"女";
        
    }else{
        sexName = @"未知";
    }
    
    //地址
    NSString *location = self.userModel.location;
    if (location == nil) {
        location = @" ";
    }
    self.addressLabel.text = [NSString stringWithFormat:@"%@  %@",sexName,location];
    
    //简介
    self.infoLabel.text = (self.userModel.description==nil)?@" ":self.userModel.description;
    
    //微博数
    NSString *count = [self.userModel.statuses_count stringValue];
    self.countLabel.text = [NSString stringWithFormat:@"共%@条微博",count];
    
    //关注数
    NSString *atts = [self.userModel.friends_count stringValue];
    self.attButton.title = atts;
    
    //粉丝数
    NSString *fans = [self.userModel.followers_count stringValue];
    self.fansButton.title = fans;
}


- (IBAction)attButtonAtion:(id)sender {
    FriendshipsViewController *friendCtrl = [[FriendshipsViewController alloc] init];
    friendCtrl.userID = self.userModel.idstr;
    [self.viewController.navigationController pushViewController:friendCtrl animated:YES];
    [friendCtrl release];
}

- (IBAction)fansButtonAtion:(id)sender {
    
}

@end
