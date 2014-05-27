//
//  MainImageScrollViews.h
//  WXWeibo
//
//  Created by 周城 on 14-5-14.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TouchBlock)(void);
typedef void(^DeleteButtonBlock)(UIButton *button);

@interface MainImageScrollViews : UIScrollView<UIScrollViewDelegate>


//一次只能用一种方式，多次赋值的话 最后一个有效
@property(nonatomic,retain)NSMutableArray *imageNames;
@property(nonatomic,retain)NSMutableArray *imageUrls;
@property(nonatomic,retain)NSMutableArray *images;
@property(nonatomic,retain)NSMutableArray *imageViews;

@property(nonatomic,retain)NSMutableArray *imageViewsSave;

@property(nonatomic,copy)TouchBlock touchBlock;

@property(nonatomic,copy)DeleteButtonBlock deleteButtonBlock;


@end
