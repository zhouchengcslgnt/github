//
//  MainImageScrollViews.m
//  WXWeibo
//
//  Created by 周城 on 14-5-14.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "MainImageScrollViews.h"
#import "ImageScrollView.h"


@implementation MainImageScrollViews


-(void)dealloc
{
    [super dealloc];
    Block_release(_touchBlock);
    Block_release(_deleteButtonBlock);
    [_imageViewsSave release];
    [_images release];
    [_imageUrls release];
    [_imageViews release];
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
    self.delegate = self;
    self.backgroundColor = [UIColor blackColor];
    self.pagingEnabled = YES;
    self.width += 10;
    
}

-(void)setImageNames:(NSMutableArray *)imageNames
{
    _imageNames = imageNames;
    [_imageNames retain];
    
    int count = [_imageNames count];
    NSMutableArray *imageArry = [[NSMutableArray alloc] initWithCapacity:count];
    
    //循环添加图片的ScrollView
    for (int i = 0; i < count; i++) {
        
        [imageArry addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }
    
    [self setImages:imageArry];
    [imageArry release];
}

-(void)setImageViews:(NSMutableArray *)imageViews
{
    _imageViews = imageViews;
    [_imageViews retain];
    
    int count = [_imageViews count];
    NSMutableArray *imageArry = [[NSMutableArray alloc] initWithCapacity:count];
    
    //循环添加图片的ScrollView
    for (int i = 0; i < count; i++) {
        UIImageView *imageView = (UIImageView *)[_imageViews objectAtIndex:i];
        
        [imageArry addObject:imageView.image];
    }
    
    [self setImages:imageArry];
    [imageArry release];
    
}

-(void)setImageUrls:(NSMutableArray *)imageUrls
{
    _imageUrls = imageUrls;
    [_imageUrls retain];
    
    int count = [_imageUrls count];
    self.contentSize = CGSizeMake((ScreenWidth + 10)*count, ScreenHeight);
    _imageViewsSave = [[NSMutableArray alloc] initWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        ImageScrollView *imageSView = [[ImageScrollView alloc] initWithFrame:CGRectMake(0 + i*(ScreenWidth + 10), 0, ScreenWidth, ScreenHeight)];
        //page
        imageSView.pageLabel.text = [NSString stringWithFormat:@"%d/%d",i+1,count];
        //image
        imageSView.imageUrl = [_imageUrls objectAtIndex:i];
        imageSView.imageBlock = ^{
            
            if (self.touchBlock) {
                _touchBlock();
            }
        };
        
        [self addSubview:imageSView];
        [_imageViewsSave addObject:imageSView];
        [imageSView release];
    }
}

-(void)setImages:(NSMutableArray *)images
{
    _images = images;
    [_images retain];
    
    int count = [_images count];
    self.contentSize = CGSizeMake((ScreenWidth + 10)*count, ScreenHeight);
    _imageViewsSave = [[NSMutableArray alloc] initWithCapacity:count];
    
    //循环添加图片的ScrollView
    for (int i = 0; i < count; i++) {
        //NSLog(@"普通的遍历：i = %d 时的数组对象为: %@",i,[_imageNames objectAtIndex: i]);
        ImageScrollView *imageSView = [[ImageScrollView alloc] initWithFrame:CGRectMake(0 + i*(ScreenWidth + 10), 0, ScreenWidth, ScreenHeight)];
        //page
        imageSView.pageLabel.text = [NSString stringWithFormat:@"%d/%d",i+1,count];
        //image
        imageSView.imageView.image = [images objectAtIndex:i];
        imageSView.imageBlock = ^{
            if (self.touchBlock) {
                _touchBlock();
            }
        };
        imageSView.deleteButtonBlock =^(UIButton *button){
            if (self.deleteButtonBlock) {
                _deleteButtonBlock(button);
            }
        };
        
        [self addSubview:imageSView];
        [_imageViewsSave addObject:imageSView];
        [imageSView release];
    }
}

#pragma mark - UIScrollViewDelegate
//滚动切换时调用,减速停止时
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //
    int count = [_imageViewsSave count];
    for (int i = 0; i < count; i++) {
        ImageScrollView *imageSV = (ImageScrollView *)[_imageViewsSave objectAtIndex:i];
        if (imageSV.zoomScale > 1) {
            imageSV.zoomScale = 1.0;
        }
        imageSV.pageLabel.hidden = NO;
    }
}

//开始滑动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDragging:%F",scrollView.contentOffset.x);
    int count = [_imageViewsSave count];
    for (int i = 0; i < count; i++) {
        ImageScrollView *imageSV = (ImageScrollView *)[_imageViewsSave objectAtIndex:i];
        imageSV.pageLabel.hidden = YES;
    }
}


@end
