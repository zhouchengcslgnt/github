//
//  singleGifWebView.h
//  WXWeibo
//
//  Created by 周城 on 14-5-17.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;
@interface singleGifWebView : UIWebView<UIWebViewDelegate>

@property(nonatomic,copy)NSString *imageUrl;

@property(nonatomic,copy)NSString *imagePath;

-(id)initWithImageurl:(NSString *)imageUrl;

@property(nonatomic,retain)MBProgressHUD *hud;


@end
