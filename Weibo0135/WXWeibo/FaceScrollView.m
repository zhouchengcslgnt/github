//
//  FaceScrollView.m
//  WXWeibo
//
//  Created by 周城 on 14-5-16.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "FaceScrollView.h"

@implementation FaceScrollView


-(void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
    Block_release(_selectFaceViewBlock);
    [_faceView release];
    [_scrollView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView
{
    _faceView = [[FaceView alloc] initWithFrame:CGRectZero];
    
    _faceView.selectBlock = ^(NSString *faceName){
        if (_selectFaceViewBlock) {
            _selectFaceViewBlock(faceName);
        }
    };
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, _faceView.height)];
    _scrollView.contentSize = CGSizeMake(_faceView.width, _faceView.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.clipsToBounds = NO;//设置没有边界
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.delegate = self;
    [_scrollView addSubview:_faceView];
    [self addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(-6*_faceView.pageNumber, _scrollView.bottom, 40, 20)];
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.numberOfPages = _faceView.pageNumber;
    _pageControl.currentPage = 0;
    [self addSubview:_pageControl];
    
    self.height = _scrollView.height + _pageControl.height;
    self.width = _scrollView.width;
    self.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    int pageNumber = _scrollView.contentOffset.x/320;
    _pageControl.currentPage = pageNumber;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    //[[UIImage imageNamed:@"emoticon_keyboard_background.png"] drawInRect:rect];
//}


@end
