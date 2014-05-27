//
//  GigWebView.m
//  WXWeibo
//
//  Created by 周城 on 14-5-17.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "GigWebView.h"
#import "singleGifWebView.h"

@implementation GigWebView

-(void)dealloc
{
    [super dealloc];
    [_webViewSave release];
    [_imageUrls release];
    Block_release(_gifWebtouchBlock);
    [_scrollView release];
    //[_selectedWebView release];
    [_pageControl release];
    
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _initView];
    }
    return self;
}

-(id)initWithImageUrls:(NSMutableArray *)imageUrls
{
    self = [super init];
    if (self) {
        [self _initView];
        self.imageUrls = imageUrls;
    }
    return self;
}

-(void)_initView
{
    
    self.webViewSave = [[NSMutableArray alloc] init];
    [_webViewSave release];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, ScreenHeight - 20)];
    
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.clipsToBounds = NO;//设置没有边界
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.delegate = self;

    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.backgroundColor = [UIColor clearColor];
    [self addSubview:_pageControl];
    [self addSubview:_scrollView];

}


//
-(void)_layoutViews
{

    [_webViewSave removeAllObjects];
    
    int count = [_imageUrls count];
    _scrollView.contentSize = CGSizeMake((ScreenWidth + 10)*count, ScreenHeight - 20);
    
    for (int i = 0; i < count; i++) {
        
        singleGifWebView *webView = (singleGifWebView *)[_scrollView viewWithTag:100*(i + 1)];
        if (webView) {
            webView.imageUrl = [_imageUrls objectAtIndex:i];
        }else{
            webView = [[singleGifWebView alloc] initWithImageurl:[_imageUrls objectAtIndex:i]];
            webView.scalesPageToFit = YES;
            webView.tag = 100*(i + 1);
            webView.frame = CGRectMake(0 + i*(ScreenWidth + 10), 0, ScreenWidth - 10, _scrollView.height);
            
            [self addTapOnWebView:webView];//加上事件
            
            [_scrollView addSubview:webView];
            [webView release];
 
        }
        
        [_webViewSave addObject:webView];
        
    }

    _pageControl.frame = CGRectMake(-10*count, _scrollView.bottom, 40, 20);
    _pageControl.numberOfPages = count;
    _pageControl.currentPage = 0;
    
    self.height = _scrollView.height + _pageControl.height;
    self.width = _scrollView.width;
    
    self.backgroundColor = [UIColor blackColor];
}

//
-(void)setImageUrls:(NSMutableArray *)imageUrls
{
    if (_imageUrls != imageUrls) {
        [_imageUrls release];
        _imageUrls = [imageUrls retain];
    }
    
    [self _layoutViews];
    
}

-(void)addTapOnWebView:(singleGifWebView *)webView
{
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.numberOfTapsRequired = 1;//点击次数
    [webView addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    
    //添加事件
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;//点击次数
    [webView addGestureRecognizer:doubleTap];//加上手势
    doubleTap.delegate = self;
    
    //设置 双击事件失败才执行单击事件
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [singleTap release];
    [doubleTap release];
}

-(void)saveImage:(NSString *)urlToSave
{
   // NSLog(@"image url=%@", urlToSave);
    if (urlToSave.length > 0) {
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlToSave]];
        UIImage* image = [UIImage imageWithData:data];
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil,nil);
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (error){
        NSLog(@"Error");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }else {
        NSLog(@"OK");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
}

#pragma mark - Action
//点击输小图片 单击
-(void)scaleImageAction
{
    if (self.gifWebtouchBlock) {
        _gifWebtouchBlock(self);
    }
}

//单击
-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self scaleImageAction];
    
}

//双击
-(void)handleDoubleTap:(UITapGestureRecognizer *)sender
{
    NSLog(@"(singleGifWebView *)sender.view:%d",[(singleGifWebView *)sender.view retainCount]);
    _selectedWebView = (singleGifWebView *)sender.view;
    NSLog(@"_selectedWebView:%d",[_selectedWebView retainCount]);
    
    _pt = [sender locationInView:_selectedWebView];
    
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", _pt.x, _pt.y];
    NSString *urlToSave = [_selectedWebView stringByEvaluatingJavaScriptFromString:imgURL];
    
    if (urlToSave.length > 0) {
        UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存图片" otherButtonTitles:@"返回到列表", nil];
        [sheet showInView:self];
        [sheet release];
    }else{
        UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"返回到列表" otherButtonTitles:nil, nil];
        [sheet showInView:self];
        [sheet release];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    int pageNumber = _scrollView.contentOffset.x/320;
    _pageControl.currentPage = pageNumber;
}

//滚动切换时调用,减速停止时
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}

#pragma mark- TapGestureRecognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSString* title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"返回到列表"] ) {
        //返回主页
        [self scaleImageAction];
        
    }else if ([title isEqualToString:@"保存图片"]){
        //保存图片
        NSLog(@"%@",NSStringFromCGPoint(_pt));
        NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", _pt.x, _pt.y];
        NSString *urlToSave = [_selectedWebView stringByEvaluatingJavaScriptFromString:imgURL];
        NSLog(@"1image url=%@", urlToSave);
        [self saveImage:urlToSave];
        
    }else if ([title isEqualToString:@"取消"]){
        //取消
        return;
    }
}

@end
