//
//  UserGridView.h
//  WXWeibo
//
//  Created by 周城 on 14-5-22.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserModel;
@interface UserGridView : UIView

@property(nonatomic,retain)UserModel *userModel;

@property (retain, nonatomic) IBOutlet UIButton *imageButton;

- (IBAction)UserImageAtion:(id)sender;

@property (retain, nonatomic) IBOutlet UILabel *nickLabel;

@property (retain, nonatomic) IBOutlet UILabel *fansLabel;

@end
