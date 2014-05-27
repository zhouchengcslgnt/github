//
//  WebViewController.h
//  WXWeibo
//
//  Created by 周城 on 14-5-6.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "BaseViewController.h"


@interface WebViewController : BaseViewController <UIWebViewDelegate>{
    NSString *_url;
}

@property (retain, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)goBack:(id)sender;

- (IBAction)goForward:(id)sender;

- (IBAction)reload:(id)sender;

-(id)initwithUrl:(NSString *)url;

@end
