//
//  FaceScrollView.h
//  WXWeibo
//
//  Created by 周城 on 14-5-16.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceView.h"

typedef void(^SelectFaceViewBlock)(NSString *faceName);

@interface FaceScrollView : UIView<UIScrollViewDelegate>{
    UIScrollView *_scrollView;
    FaceView *_faceView;
    UIPageControl *_pageControl;
}

@property(nonatomic,copy)SelectFaceViewBlock selectFaceViewBlock;

@end
