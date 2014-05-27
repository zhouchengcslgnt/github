//
//  BaseImageView.h
//  WXWeibo
//
//  Created by 周城 on 14-5-5.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImageBlock)(void);

@interface BaseImageView : UIImageView

@property(nonatomic,copy)ImageBlock touchBlock;

@end
