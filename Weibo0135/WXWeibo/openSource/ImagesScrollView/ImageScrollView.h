//
//  ImageScrollView.h
//  WXWeibo
//
//  Created by 周城 on 14-5-14.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImageTouchBlock)(void);
typedef void(^DelButtonBlock)(UIButton *button);

@interface ImageScrollView : UIScrollView<UIScrollViewDelegate>
{
    UIButton *_deleteButton;
}

@property(nonatomic,retain)UIImageView *imageView;

@property(nonatomic,retain)UILabel *pageLabel;

@property(nonatomic,copy)ImageTouchBlock imageBlock;

@property(nonatomic ,copy)NSString *imageUrl;

@property(nonatomic,copy)DelButtonBlock deleteButtonBlock;

@end
