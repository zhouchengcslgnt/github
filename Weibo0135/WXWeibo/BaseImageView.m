//
//  BaseImageView.m
//  WXWeibo
//
//  Created by 周城 on 14-5-5.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "BaseImageView.h"

@implementation BaseImageView

-(void)dealloc
{
    [super dealloc];
    Block_release(_touchBlock);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}

//用xib创建时 调用这个初始化方法
-(void)awakeFromNib
{
    [self _init];
}

-(void)_init
{
    self.userInteractionEnabled = YES;//开启触摸
    //加点击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tapGesture];
    [tapGesture autorelease];
}

-(void)tapAction:(UITapGestureRecognizer *)tapGesture
{
    if (self.touchBlock) {
        _touchBlock();
    }
}

@end
