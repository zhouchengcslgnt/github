//
//  UIFactory.m
//  WXWeibo
//
//  Created by wei.chen on 13-1-22.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "UIFactory.h"

@implementation UIFactory

+ (ThemeButton *)createButton:(NSString *)imageName highlighted:(NSString *)highlightedName {
    ThemeButton *button = [[ThemeButton alloc] initWithImage:imageName highlighted:highlightedName];
    return [button autorelease];
}

+ (ThemeButton *)createButtonWithBackground:(NSString *)backgroundImageName
                      backgroundHighlighted:(NSString *)highlightedName {
    ThemeButton *button = [[ThemeButton alloc] initWithBackground:backgroundImageName highlightedBackground:highlightedName];
    return [button autorelease];
}

//创建导航栏上的按钮
+(ThemeButton *)createNavigationButton:(CGRect)frame
                              title:(NSString *)title
                             target:(id)target
                             action:(SEL)action
{
    ThemeButton *button = [self createButtonWithBackground:@"navigationbar_button_background.png" backgroundHighlighted:@"navigationbar_button_delete_background.png"];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    button.leftCapWidth = 3;
    
    return button;
}

+ (ThemeImageView *)createImageView:(NSString *)imageName {
    ThemeImageView *themeImage = [[ThemeImageView alloc] initWithImageName:imageName];
    return [themeImage autorelease];
}

+ (ThemeLabel *)createLabel:(NSString *)colorName {
    ThemeLabel *themeLabel = [[ThemeLabel alloc] initWithColorName:colorName];
    return [themeLabel autorelease];
}

@end
