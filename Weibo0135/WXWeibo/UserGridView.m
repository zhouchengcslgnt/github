//
//  UserGridView.m
//  WXWeibo
//
//  Created by 周城 on 14-5-22.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "UserGridView.h"
#import "UserModel.h"
#import "UIButton+WebCache.h"
#import "UserViewController.h"

@implementation UserGridView

- (void)dealloc {
    [_imageButton release];
    [_nickLabel release];
    [_fansLabel release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *gridView = [[[NSBundle mainBundle] loadNibNamed:@"UserGridView" owner:self options:nil] lastObject];
        self.size = gridView.size;
        [self addSubview:gridView];
        UIImage *image = [UIImage imageNamed:@"profile_button3_1.png"];
        UIImageView *backgroudView = [[UIImageView alloc] initWithImage:image];
        [self insertSubview:backgroudView atIndex:0];
        [backgroudView release];
        
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //昵称
    self.nickLabel.text =_userModel.screen_name;
    //粉丝数
    long favo = [self.userModel.followers_count longValue];
    NSString *fans = [NSString stringWithFormat:@"%ld",favo];
    if (favo > 10000) {
        favo = favo/10000;
        fans = [NSString stringWithFormat:@"%ld万",favo];
    }
    self.fansLabel.text = fans;
    
    //用户头像
    NSString *urlstring = self.userModel.profile_image_url;
    [self.imageButton setImageWithURL:[NSURL URLWithString:urlstring]];
}

- (IBAction)UserImageAtion:(id)sender {
    UserViewController *userCtrl = [[UserViewController alloc] init];
    userCtrl.userName = self.userModel.screen_name;
    [self.viewController.navigationController pushViewController:userCtrl animated:YES];
    [userCtrl release];
}
@end
