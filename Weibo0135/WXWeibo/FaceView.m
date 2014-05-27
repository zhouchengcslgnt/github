//
//  FaceView.m
//  WXWeibo
//
//  Created by 周城 on 14-5-16.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "FaceView.h"

#define item_width 42
#define item_height 45

@implementation FaceView

-(void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
    Block_release(_selectedFaceName);
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initData];
    }
    return self;
}

/**
 *行  row:4
 *列  colum:7
 *表情尺寸 30 x 30 pixels
 */
/*
 *items = [
                ["表情1","表情2","表情3",..."表情28"],
                ["表情1","表情2","表情3",..."表情28"],
                ["表情1","表情2","表情3",..."表情28"]
 
          ];
 */
-(void)initData
{
    _items = [[NSMutableArray alloc] init];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *fileArray = [NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray *items2D = nil;
    for (int i = 0; i<fileArray.count; i++) {
        NSDictionary *item = [fileArray objectAtIndex:i];
        if (i % 28 == 0) {
            items2D = [NSMutableArray arrayWithCapacity:28];
            [_items addObject:items2D];
        }
        [items2D addObject:item];
    }
    
    //保存页数
    _pageNumber = _items.count;
    
    //设置尺寸
    self.width = _items.count * 320;
    self.height = 4 * item_height;
    
    //设置放大镜
    _magnifierView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emoticon_keyboard_magnifier.png"]];
    _magnifierView.frame = CGRectMake(0, 0, 64, 92);
    _magnifierView.hidden = YES;
    _magnifierView.backgroundColor = [UIColor clearColor];
    
    //放大镜上的表情
    UIImageView *faceItem = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 30, 30)];
    faceItem.tag = 10;
    faceItem.backgroundColor = [UIColor clearColor];
    
    [_magnifierView addSubview:faceItem];
    [self addSubview:_magnifierView];
    [faceItem release];

}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //定义列和行
    int row = 0,colum = 0;
    
    for (int i = 0; i<_items.count; i++) {
        NSArray *items2D = [_items objectAtIndex:i];
        
        for (int j = 0; j<items2D.count; j++) {
            NSDictionary *item = [items2D objectAtIndex:j];
            NSString *imageName = [item objectForKey:@"png"];
            UIImage *image = [UIImage imageNamed:imageName];
            
            CGRect frame = CGRectMake(colum*item_width + 15, row*item_height + 15, 30, 30);
            
            //考虑页数，需要加上前几页的宽度
            float x = (i*320) + frame.origin.x;
            frame.origin.x = x;
            // 画图片
            [image drawInRect:frame];
            
            
            //更新列额行
            colum++;
            if (colum % 7 == 0) {
                row ++;
                colum = 0;
            }
            if (row == 4) {
                row = 0;
            }
        }
    }
    
}

-(void)touchFace:(CGPoint)point
{
   // NSLog(@"point:%@",NSStringFromCGPoint(point));
    
    //页数
    int page = point.x / 320;
    //每页的坐标
    float x = point.x-(page*320) -10;
    float y = point.y -10;
    
    //计算列
    int colum = x / item_width;
    int row = y / item_height;
    
    if (colum > 6) {
        colum = 6;
    }
    if (colum < 0 ) {
        colum= 0;
    }
    if (row > 3) {
        row = 3;
    }
    if (row < 0) {
        row = 0;
    }
    
    //计算在数组的索引
    int index = colum + (row*7);
    
    //取得页的数组
    NSArray *items2D = [_items objectAtIndex:page];
    //取得某一页的某一个表情
    NSDictionary *item = [items2D objectAtIndex:index];
    NSString *faceName = [item objectForKey:@"chs"];
//    NSLog(@"%@",faceName);
    NSString *imageName = [item objectForKey:@"png"];
    
    
    if (![_selectedFaceName isEqualToString:faceName] || _selectedFaceName == nil) {
        
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *faceItem = (UIImageView *)[_magnifierView viewWithTag:10];//取得放大镜的表情View
        faceItem.image = image;
        //改变放大镜的frame
        _magnifierView.left = (page*320) + colum*item_width;
        _magnifierView.bottom = row*item_height + 30;
        _magnifierView.hidden = NO;
        
        _selectedFaceName = faceName;
    }
    
    
}

//touch事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self touchFace:point];
    
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scollView = (UIScrollView *)self.superview;
        scollView.scrollEnabled = NO;
    }
}

//touch移动
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self touchFace:point];
}

//touch结束
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _magnifierView.hidden = YES;
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scollView = (UIScrollView *)self.superview;
        scollView.scrollEnabled = YES;
    }
    
    if (_selectBlock) {
        _selectBlock(_selectedFaceName);
    }

    _selectedFaceName = nil;
}

//touch取消
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _magnifierView.hidden = YES;
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scollView = (UIScrollView *)self.superview;
        scollView.scrollEnabled = YES;
        _selectedFaceName = nil;
    }
    
}

@end
