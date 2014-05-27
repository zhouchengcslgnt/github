//
//  ImageScrollView.m
//  WXWeibo
//
//  Created by 周城 on 14-5-14.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "ImageScrollView.h"
#import "UIImageView+WebCache.h"


@implementation ImageScrollView

-(void)dealloc
{
    [super dealloc];
    [_imageView release];
    [_deleteButton release];
    [_imageUrl release];
    Block_release(_imageBlock);
    Block_release(_deleteButtonBlock);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}

-(void)_init
{
    self.backgroundColor = [UIColor blackColor];
    self.delegate = self;
    //默认下放大和缩小的尺寸
    self.minimumZoomScale = 1;
    self.maximumZoomScale = 2;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    //创建imageView
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 25)];
    _imageView.backgroundColor = [UIColor blackColor];
    //当视图对象的userInteractionEnabled设置为NO的时候，用户触发的事件，如触摸，键盘等，将会被该视图忽略（其他视图照常响应），并且该视图对象也会从事件响应队列中被移除。 当userInteractionEnabled设为YES时，则事件可以正常的传递给该视图对象。
    _imageView.userInteractionEnabled = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;//不拉伸 正常图片显示
    
    //添加手势 点击缩小
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImageAction:)];
    tapGesture.numberOfTapsRequired = 1;//点击次数
    [_imageView addGestureRecognizer:tapGesture];//加上手势
    
    //添加事件
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomInOrOut:)];
    doubleTap.numberOfTapsRequired = 2;//点击次数
    [_imageView addGestureRecognizer:doubleTap];//加上手势
    
    //设置 双击事件失败才执行单击事件
    [tapGesture requireGestureRecognizerToFail:doubleTap];
    [tapGesture release];
    [doubleTap release];
    
    //加上删除按钮
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteButton setImage:[UIImage imageNamed:@"trash.png"] forState:UIControlStateNormal];
    _deleteButton.frame = CGRectMake(ScreenWidth - 40, 40, 20, 20);
    _deleteButton.backgroundColor = [UIColor clearColor];
    [_deleteButton addTarget:self action:@selector(deleteAtion:) forControlEvents:UIControlEventTouchUpInside];
    [_imageView addSubview:_deleteButton];
    
    
    //加上page
    _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 20, ScreenHeight - 20, 20, 10)];
    _pageLabel.backgroundColor = [UIColor clearColor];
    _pageLabel.font = [UIFont systemFontOfSize:12.0f];
    _pageLabel.textAlignment = NSTextAlignmentCenter;
    _pageLabel.textColor = [UIColor whiteColor];
    
    [self addSubview:_pageLabel];
    [self addSubview:_imageView];
    [_pageLabel release];
    [_imageView release];
    
}

-(void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    [_imageUrl retain];
    
    //设置等待动画
    NSMutableArray *imageArray = [[[NSMutableArray alloc] init] autorelease];
    [imageArray addObject:[UIImage imageNamed:@"page_image_loading.png"]];
    [imageArray addObject:[UIImage imageNamed:@"page_image_loading_hlighted.png"]];
    //加载图片
    [_imageView setImageWithURL:[NSURL URLWithString:_imageUrl] imageArray:imageArray];
}

#pragma mark - Action
//点击输小图片 单击
-(void)scaleImageAction:(UITapGestureRecognizer *)tap
{
    if (self.imageBlock) {
        _imageBlock();
    }
}

//双击
-(void)zoomInOrOut:(UITapGestureRecognizer *)tap
{
    if (self.zoomScale >= 2) {
        [self setZoomScale:1 animated:YES];//还原
    }else{
        //获取点击的位置
        CGPoint poit = [tap locationInView:self.imageView];
        //放大
        [self zoomToRect:CGRectMake(poit.x - 10, poit.y - 10, 40, 40) animated:YES];
    }
}

//删除按钮
-(void)deleteAtion:(UIButton *)deleteButton
{
    if (self.deleteButtonBlock) {
        _deleteButtonBlock(deleteButton);
    }
    
    
}

#pragma mark - UIScrollViewDelegate
//返回一个放大或缩小的视图
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    
    return _imageView;
}// return a view that will be scaled. if delegate returns nil, nothing happens

//开始放大或者缩小
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view NS_AVAILABLE_IOS(3_2)
{
    _pageLabel.hidden = YES;
} // called before the scroll view begins zooming its content

//缩放结束
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if (scrollView.zoomScale == 1) {
        _pageLabel.hidden = NO;
    }
}// scale between minimum and maximum. called after any 'bounce' animations


@end
