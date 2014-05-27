//
//  UserInfoView.h
//  WXWeibo
//
//  Created by 周城 on 14-5-4.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RectButton;
@class UserModel;
@interface UserInfoView : UIView

@property(nonatomic,retain)UserModel *userModel;

@property (retain, nonatomic) IBOutlet UIImageView *userImage;

@property (retain, nonatomic) IBOutlet UILabel *nameLabel;

@property (retain, nonatomic) IBOutlet UILabel *addressLabel;

@property (retain, nonatomic) IBOutlet UILabel *infoLabel;

@property (retain, nonatomic) IBOutlet RectButton *attButton;

@property (retain, nonatomic) IBOutlet RectButton *fansButton;

@property (retain, nonatomic) IBOutlet UILabel *countLabel;

- (IBAction)attButtonAtion:(id)sender;

- (IBAction)fansButtonAtion:(id)sender;


@end
