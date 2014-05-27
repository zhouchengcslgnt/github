//
//  singleGifWebView.m
//  WXWeibo
//
//  Created by 周城 on 14-5-17.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "singleGifWebView.h"
#import "MBProgressHUD.h"

@implementation singleGifWebView

-(void)dealloc
{
    [super dealloc];
    [_imageUrl release];
    [_hud release];
    [_imagePath release];  
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithImageurl:(NSString *)imageUrl
{
    self = [super init];
    if (self) {
        [self setImageUrl:imageUrl];
    }
    
    return self;
    
}

-(void)_initView
{
    self.backgroundColor = [UIColor clearColor];
    self.scalesPageToFit = YES;
    self.delegate = self;
    
    
}

-(void)setImageUrl:(NSString *)imageUrl
{
    if (_imageUrl != imageUrl) {
        [_imageUrl release];
        _imageUrl = [imageUrl copy];
    }
    NSURL *url = [NSURL URLWithString:_imageUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self loadRequest:request];
    
    [self _initView];
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    self.hud.dimBackground = NO;
    self.hud.labelText = @"正在加载...";
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_hud hide:YES];
}

@end
