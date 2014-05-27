//
//  UIView+Addtions.m
//  WXWeibo
//
//  Created by 周城 on 14-5-4.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

-(UIViewController *)viewController
{
    // 下一个响应者 事件链
    UIResponder *next = [self nextResponder];
    
    do {
        //若是 UIViewController
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        
        next = [next nextResponder];
        
    } while (next != nil);
    
    return nil;
}

@end
