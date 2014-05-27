//
//  FaceView.h
//  WXWeibo
//
//  Created by 周城 on 14-5-16.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectBlock)(NSString *faceName);

@interface FaceView : UIView{
    NSMutableArray *_items;
    UIImageView *_magnifierView;
}

@property(nonatomic,copy)NSString *selectedFaceName;
@property(nonatomic,assign)NSInteger pageNumber;
@property(nonatomic,copy)SelectBlock selectBlock;

@end
