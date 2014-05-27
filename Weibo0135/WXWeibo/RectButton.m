//
//  RectButton.m
//  WXWeibo
//
//  Created by 周城 on 14-5-4.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "RectButton.h"

@implementation RectButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initButton];
    }
    return self;
}

-(void)awakeFromNib
{
    [self _initButton];
}

-(void)_initButton
{
    _topTitleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    _topTitleLabel.backgroundColor =[UIColor clearColor];
    _topTitleLabel.font = [UIFont systemFontOfSize:14.0];
    _topTitleLabel.textColor = [UIColor blueColor];
    [self addSubview:_topTitleLabel];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _topTitleLabel.text = _title;
    _topTitleLabel.frame = CGRectMake(0, 15, 70, 20);
    self.titleLabel.frame = CGRectMake(0, 35, 70, 20);
    //字体居中
    _topTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end
