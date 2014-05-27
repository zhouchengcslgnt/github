//
//  WeiboAnnotationView.m
//  WXWeibo
//
//  Created by 周城 on 14-5-20.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "WeiboAnnotationView.h"

@implementation WeiboAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        [self initView];
    }
    return self;
}

-(void)initView
{
    _userImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    _weiboImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    _weiboImage.contentMode = UIViewContentModeScaleAspectFit;
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _textLabel.font = [UIFont systemFontOfSize:12.0f];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.backgroundColor = [UIColor blackColor];
    _textLabel.numberOfLines = 3;
    
    [self addSubview:_userImage];
    [self addSubview:_weiboImage];
    [self addSubview:_textLabel];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.image = [UIImage imageNamed:@"nearby_map_content.png"];
}

@end
