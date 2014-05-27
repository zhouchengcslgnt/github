//
//  WeiboView.m
//  WXWeibo
//
//  Created by 周城 on 14-5-6.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "WeiboView.h"
#import "UIFactory.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
#import "ThemeImageView.h"
#import "RegexKitLite.h"
#import "NSString+URLEncoding.h"
#import "UIUtils.h"
#import "UserViewController.h"
#import "WebViewController.h"
#import "MainImageScrollViews.h"
#import "GigWebView.h"

#define LIST_FONT   14.0f           //列表中文本字体
#define LIST_REPOST_FONT  13.0f;    //列表中转发的文本字体
#define DETAIL_FONT  17.0f          //详情的文本字体
#define DETAIL_REPOST_FONT 16.0f    //详情中转发的文本字体

@implementation WeiboView

-(void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}

//初始化子视图
- (void)_initView {
    //微博内容
    _textLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
    _textLabel.delegate = self;
    _textLabel.font = [UIFont systemFontOfSize:14.0f];
    //十进制RGB值：r:69 g:149 b:203
    //十六进制RGB值：4595CB
    //设置链接的颜色
    _textLabel.linkAttributes = [NSDictionary dictionaryWithObject:@"#4595CB" forKey:@"color"];//三色值
    //设置链接高亮的颜色
    _textLabel.selectedLinkAttributes = [NSDictionary dictionaryWithObject:@"darkGray" forKey:@"color"];
    [self addSubview:_textLabel];
    [_textLabel autorelease];
    
    //微博图片
    _image = [[UIImageView alloc] initWithFrame:CGRectZero];
    _image.backgroundColor = [UIColor clearColor];
    _image.image = [UIImage imageNamed:@"page_image_loading.png"];
    //设置图片的内容显示模式：等比例缩/放（不会被拉伸或压缩）
    _image.contentMode = UIViewContentModeScaleAspectFit;
    [_image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)]];
    _image.userInteractionEnabled = YES;//UIImageView默认是不能响应手势的，需要开启
    [self addSubview:_image];
    [_image autorelease];
    
    //转发微博视图的背景
    _repostBackgroudView = [UIFactory createImageView:@"timeline_retweet_background.png"];
    UIImage *image = [_repostBackgroudView.image stretchableImageWithLeftCapWidth:25 topCapHeight:10];//设置拉伸
    _repostBackgroudView.image = image;
    //设置拉伸，切换主题时，返回图片的时候要用到的
    _repostBackgroudView.leftCapWidth = 25;
    _repostBackgroudView.topCapHeight = 10;
    _repostBackgroudView.backgroundColor = [UIColor clearColor];
    [self insertSubview:_repostBackgroudView atIndex:0];
    
}

- (void)setWeiboModel:(WeiboModel *)weiboModel {
    if (_weiboModel != weiboModel) {
        [_weiboModel release];
        _weiboModel = [weiboModel retain];
        [self layoutSubviews];//手动触发下，有时候不刷新不知道为什么，所以手动触发下
    }
    
    //创建转发微博视图
    if (_repostView == nil) {
        _repostView = [[WeiboView alloc] initWithFrame:CGRectZero];
        if (self.isDetail) {
            _repostView.isDetail = YES;
        }else{
            _repostView.isDetail = NO;
        }
        _repostView.isRepost = YES;
        [self addSubview:_repostView];
        [_repostView autorelease];
    }
    
    //解析内容
    _parseText = [[NSMutableString alloc] init];//必须初始化成字符串
    [self parseLink:_weiboModel.text];
    
}

//利用正则表达式解析内容，加上超链接格式
-(void)parseLink:(NSString *)text
{
    if (text == nil) {
        [_parseText setString:@""];
        return;
    }
    //因为自己重用自己了，所以变量值要清空下，或重新赋值下
    [_parseText setString:@""];
    
    //判断当前微博是否是转发的微博
    if (_isRepost) {
        //将原微博拼接
        //原微博作者昵称
        NSString *nickName = _weiboModel.user.screen_name;
        NSString *encodeName = [nickName URLEncodedString];
        [_parseText appendFormat:@"<a href='user://%@'>%@</a>: ",encodeName,nickName];
    }
    
    text = [UIUtils parseLink:text];
       
    [_parseText appendString:text];
}

//layoutSubviews 展示数据、子视图布局
//layoutSubviews 有可能会调用多次
- (void)layoutSubviews {
    [super layoutSubviews];
    
    //---------------微博内容_textLabel子视图------------------
    //获取字体大小
    float fontSize = [WeiboView getFontSize:self.isDetail isRepost:self.isRepost];
    _textLabel.font = [UIFont systemFontOfSize:fontSize];
    _textLabel.frame = CGRectMake(0, 0, self.width, 20);
    //判断当前视图是否为转发视图
    if (self.isRepost) {
        _textLabel.frame = CGRectMake(10, 10, self.width-20, 0);
        
    }
    //内容
    _textLabel.text = _parseText;
    
    //文本内容尺寸
    CGSize textSize = _textLabel.optimumSize;
    _textLabel.height = textSize.height;
    
    
    //---------------转发的微博视图_repostView------------------
    //转发的微博model 重用自己，自己的变量值会保留，要注意
    WeiboModel *repostWeiboModel = _weiboModel.relWeibo;
    //判断是否有转发的微博数据
    if (repostWeiboModel != nil) {
        _repostView.hidden = NO;
        _repostView.weiboModel = repostWeiboModel;
        
        //计算转发微博视图的高度
        float height = [WeiboView getWeiboViewHeight:repostWeiboModel isRepost:YES isDetail:self.isDetail];
        _repostView.frame = CGRectMake(0, _textLabel.bottom, self.width, height);
    } else {
        _repostView.hidden = YES;
    }
    
    
    //---------------微博图片视图_image------------------
    if (self.isDetail) {
        //中等尺寸图片地址
        NSString *bmiddleImage = _weiboModel.bmiddleImage;
        if (bmiddleImage != nil && ![@"" isEqualToString:bmiddleImage]) {
            _image.hidden = NO;
            _image.frame = CGRectMake(10, _textLabel.bottom+10, 280, 200);
            
            //加载网络图片数据
          //  [_image setImageWithURL:[NSURL URLWithString:bmiddleImage] placeholderImage:[UIImage imageNamed:@"page_image_loading.png"]];
            
            NSMutableArray *imageArray = [[[NSMutableArray alloc] init] autorelease];
            [imageArray addObject:[UIImage imageNamed:@"page_image_loading.png"]];
            [imageArray addObject:[UIImage imageNamed:@"page_image_loading_hlighted.png"]];
            
            [_image setImageWithURL:[NSURL URLWithString:bmiddleImage] imageArray:imageArray];
            
        } else {
            _image.hidden = YES;
        }

    }else{
        //缩略图片地址
        NSString *thumbnailImage = _weiboModel.thumbnailImage;
        if (thumbnailImage != nil && ![@"" isEqualToString:thumbnailImage]) {
            _image.hidden = NO;
            _image.frame = CGRectMake(10, _textLabel.bottom+10, 70, 80);
            
            //加载网络图片数据
            NSMutableArray *imageArray = [[[NSMutableArray alloc] init] autorelease];
            [imageArray addObject:[UIImage imageNamed:@"page_image_loading.png"]];
            [imageArray addObject:[UIImage imageNamed:@"page_image_loading_hlighted.png"]];
            
            [_image setImageWithURL:[NSURL URLWithString:thumbnailImage] imageArray:imageArray];
        } else {
            _image.hidden = YES;
        }
    }
    
    //----------------转发的微博视图背景_repostBackgroudView---------------
    if (self.isRepost) {
        _repostBackgroudView.frame = self.bounds;
        _repostBackgroudView.hidden = NO;
    } else {
        _repostBackgroudView.hidden = YES;
    }

    
}

#pragma mark - 计算
//获取字体大小
+ (float)getFontSize:(BOOL)isDetail isRepost:(BOOL)isRepost {
    float fontSize = 14.0f;
    
    if (!isDetail && !isRepost) {
        return LIST_FONT;
    }
    else if(!isDetail && isRepost) {
        return LIST_REPOST_FONT;
    }
    else if(isDetail && !isRepost) {
        return DETAIL_FONT;
    }
    else if(isDetail && isRepost) {
        return DETAIL_REPOST_FONT;
    }
    
    return fontSize;
}

//计数微博视图的高度
+ (CGFloat)getWeiboViewHeight:(WeiboModel *)weiboModel
                     isRepost:(BOOL)isRepost
                     isDetail:(BOOL)isDetail {
    /**
     *   实现思路：计算每个子视图的高度，然后相加。
     **/
    float height = 0;
    
    //--------------------计算微博内容text的高度------------------------
    RTLabel *textLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
    float fontsize = [WeiboView getFontSize:isDetail isRepost:isRepost];
    textLabel.font = [UIFont systemFontOfSize:fontsize];
    //判断此微博是否显示在详情页面
    if (isDetail) {
        textLabel.width = kWeibo_Width_Detail;
    } else {
        textLabel.width = kWeibo_Width_List;
    }
    if (isRepost) {
        textLabel.width -= 20;
    }
    textLabel.text = weiboModel.text;
    //获取填充后的高度
    height += textLabel.optimumSize.height;
    
    //--------------------计算微博图片的高度------------------------
    if (isDetail) {
        NSString *bmiddleImage = weiboModel.bmiddleImage;
        if (bmiddleImage != nil && ![@"" isEqualToString:bmiddleImage]) {
            height += (200+20);
        }
    }else{
        NSString *thumbnailImage = weiboModel.thumbnailImage;
        if (thumbnailImage != nil && ![@"" isEqualToString:thumbnailImage]) {
            height += (80+20);
        }
    }
    
    //--------------------计算转发微博视图的高度------------------------
    //转发的微博
    WeiboModel *relWeibo = weiboModel.relWeibo;
    if (relWeibo != nil) {
        //转发微博视图的高度
        float repostHeight = [WeiboView getWeiboViewHeight:relWeibo isRepost:YES isDetail:isDetail];
        height += (repostHeight);
    }
    
    if (isRepost == YES) {
        height += 30;
    }
    [textLabel release];
    return height;
}

-(void)imageClick:(UIGestureRecognizer *)gestureRecognizer
{
    
//    UIImageView *image = [[UIImageView alloc] init];
//    UIImageView *image = (UIImageView *)[gestureRecognizer view];
    //加载网络原始图片数据
    NSString *originalImage = _weiboModel.originalImage == nil ? _weiboModel.bmiddleImage : _weiboModel.originalImage;
    NSLog(@"图片的点击:%@",originalImage);
    //放大图片
    [self imageAction:originalImage];
}

//全屏放大图片
-(void)imageAction:(NSString *)imageUrl
{
    
    if (imageUrl.length <= 0) {
        return;
    }
    if (_isImageClicked) {
        return;
    }
    
//    //ImageView的创建
//    if (_scrollView == nil) {
//        _scrollView = [[[MainImageScrollViews alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)] autorelease];
//        _scrollView.touchBlock = ^{
//            [self scaleImageAction:nil];
//        };
//        
//    }
//    //图片数组
//    NSMutableArray *imageUrls = [[NSMutableArray alloc] init];
//    [imageUrls addObject:imageUrl];
//    [imageUrls addObject:imageUrl];//测试用的
//    _scrollView.imageUrls = imageUrls;
//    [imageUrls autorelease];
//    
//    
//    //判断是否有superview，没有的话就添加上去
//    if (![_scrollView superview]) {
//        
//        [self.window addSubview:_scrollView];
//        
//        //加个放大的动画效果
//        _scrollView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);//初始放大的位置
//        [UIView animateWithDuration:0.4 animations:^{
//            _scrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//            
//        } completion:^(BOOL finished){
//            [UIApplication sharedApplication].statusBarHidden = YES;//状态栏的隐藏
//        }];
//    }
    
    
    _isImageClicked = YES;
    //图片数组
    NSMutableArray *imageUrls = [[NSMutableArray alloc] init];
    [imageUrls addObject:imageUrl];
    [imageUrls addObject:imageUrl];//测试用的

    //GigWebView *gifWebView = [[GigWebView alloc] initWithImageUrls:imageUrls];
    GigWebView *gifWebView = [[GigWebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    gifWebView.gifWebtouchBlock = ^(id gifWebViewblock){
        [self scaleImageAction:gifWebViewblock];
    };

    gifWebView.imageUrls = imageUrls;
    [imageUrls release];
 
    //判断是否有superview，没有的话就添加上去
    if (![gifWebView superview]) {
        
        [self.window addSubview:gifWebView];
        //加个放大的动画效果
        gifWebView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);//初始放大的位置
        [UIView animateWithDuration:0.4 animations:^{
            gifWebView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);

        } completion:^(BOOL finished){
            [UIApplication sharedApplication].statusBarHidden = YES;//状态栏的隐藏
            [gifWebView release];
        }];
    }

}

//点击输小图片
-(void)scaleImageAction:(id)gifWebView
{
//    [UIApplication sharedApplication].statusBarHidden = NO;
//    [UIView animateWithDuration:0.4 animations:^{
//        _scrollView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
//    } completion:^(BOOL finished) {
//        [_scrollView removeFromSuperview];
//    }];
    GigWebView *gifWView = (GigWebView *)gifWebView;
    _isImageClicked = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIView animateWithDuration:0.4 animations:^{
        gifWView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
    } completion:^(BOOL finished) {
        [gifWView removeFromSuperview];
    }];
    
}


#pragma mark - RTLabel delegate
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url {
    
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
        NSLog(@"用户:%@",urlString);
        //用户个人资料
        UserViewController *userInfoViewCtrl = [[[UserViewController alloc] init] autorelease];
        userInfoViewCtrl.userName = urlString;
        //响应者链来获得Controller
        [self.viewController.navigationController pushViewController:userInfoViewCtrl animated:YES];
        
        
    }else if ([absoluteString hasPrefix:@"http"])
    {
        NSLog(@"网址:%@",absoluteString);
        WebViewController *webView = [[WebViewController alloc] initwithUrl:absoluteString];
        [self.viewController.navigationController pushViewController:webView animated:YES];
        [webView release];
        
        
    }else if ([absoluteString hasPrefix:@"topic"])
    {
        urlString = [urlString URLDecodedString];
        NSLog(@"话题:%@",urlString);
    }
    
}

@end
