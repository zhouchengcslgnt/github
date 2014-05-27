//
//  GigWebView.h
//  WXWeibo
//
//  Created by 周城 on 14-5-17.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GifWebtouchBlock)(id gifWebViewblock);

@class singleGifWebView;
@interface GigWebView : UIView<UIScrollViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate>{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    CGPoint _pt;
    singleGifWebView *_selectedWebView;
}

@property(nonatomic,retain)NSMutableArray *imageUrls;

@property(nonatomic,retain)NSMutableArray *webViewSave;

@property(nonatomic,retain)NSMutableArray *webViewSave1;

-(id)initWithImageUrls:(NSMutableArray *)imageUrls;

@property(nonatomic,copy)GifWebtouchBlock gifWebtouchBlock;

@end
