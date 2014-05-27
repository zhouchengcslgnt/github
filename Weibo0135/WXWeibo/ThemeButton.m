//
//  ThemeButton.m
//  WXWeibo
//
//  Created by wei.chen on 13-1-22.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "ThemeButton.h"
#import "ThemeManager.h"

@implementation ThemeButton

- (id)initWithImage:(NSString *)imageName highlighted:(NSString *)highligtImageName {
    self = [self init];
    if (self) {
        self.imageName = imageName;
        self.highligtImageName = highligtImageName;
    }
    return self;
}

- (id)initWithBackground:(NSString *)backgroundImageName
   highlightedBackground:(NSString *)backgroundHighligtImageName {
    self = [self init];
    if (self) {
        self.backgroundImageName = backgroundImageName;
        self.backgroundHighligtImageName = backgroundHighligtImageName;
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        //监听主题切换的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNofication object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

-(void)setLeftCapWidth:(int)leftCapWidth
{
    _leftCapWidth = leftCapWidth;
    [self loadThemeImage];
    
}

-(void)setTopCapHeight:(int)topCapHeight
{
    _topCapHeight = topCapHeight;
    [self loadThemeImage];
}

#pragma mark - NSNotification action
//切换主题的通知
- (void)themeNotification:(NSNotification *)notification {
    [self loadThemeImage];
}

//加载图片
- (void)loadThemeImage {
    ThemeManager *themeManager = [ThemeManager shareInstance];
    
    UIImage *image = [themeManager getThemeImage:_imageName];
    UIImage *highligtImage = [themeManager getThemeImage:_highligtImageName];
    
    //设置拉伸
    image = [image stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapHeight];
    highligtImage = [highligtImage stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapHeight];
    
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:highligtImage forState:UIControlStateHighlighted];
    
    
    UIImage *backImage = [themeManager getThemeImage:_backgroundImageName];
    UIImage *backHighligtImage = [themeManager getThemeImage:_backgroundHighligtImageName];

    //设置拉伸
    backImage = [backImage stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapHeight];
    backHighligtImage = [backHighligtImage stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapHeight];
    
    [self setBackgroundImage:backImage forState:UIControlStateNormal];
    [self setBackgroundImage:backHighligtImage forState:UIControlStateHighlighted];
    
}

#pragma mark - setter  设置图片名后，重新加载该图片名对应的图片
- (void)setImageName:(NSString *)imageName {
    if (_imageName != imageName) {
        [_imageName release];
        _imageName = [imageName copy];
    }
    //重新加载图片
    [self loadThemeImage];
}

- (void)setHighligtImageName:(NSString *)highligtImageName {
    if (_highligtImageName != highligtImageName) {
        [_highligtImageName release];
        _highligtImageName = [highligtImageName copy];
    }
    
    //重新加载图片
    [self loadThemeImage];
}

- (void)setBackgroundImageName:(NSString *)backgroundImageName {
    if (_backgroundImageName != backgroundImageName) {
        [_backgroundImageName release];
        _backgroundImageName = [backgroundImageName copy];
    }
    
    //重新加载图片
    [self loadThemeImage];
}

- (void)setBackgroundHighligtImageName:(NSString *)backgroundHighligtImageName {
    if (_backgroundHighligtImageName != backgroundHighligtImageName) {
        [_backgroundHighligtImageName release];
        _backgroundHighligtImageName = [backgroundHighligtImageName copy];
    }
    
    //重新加载图片
    [self loadThemeImage];
}


@end
