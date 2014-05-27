//
//  SendViewController.h
//  WXWeibo
//
//  Created by 周城 on 14-5-6.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "BaseViewController.h"

@class MainImageScrollViews;
@class FaceScrollView;
@interface SendViewController : BaseViewController<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextViewDelegate>{
   
    NSMutableArray *_buttons;
    //表情视图
    FaceScrollView *_faceView;
    
}

@property(nonatomic,copy)NSString *latitude;
@property(nonatomic,copy)NSString *longitude;
@property(nonatomic,retain)UIImage *sendImage;
@property(nonatomic,retain)UIImageView *sendImageView;

@property(nonatomic,retain)MainImageScrollViews *scrollView;

@property (retain, nonatomic) IBOutlet UITextView *textView;

@property (retain, nonatomic) IBOutlet UIView *editorBar;

@property (retain, nonatomic) IBOutlet UIView *placeView;

@property (retain, nonatomic) IBOutlet UILabel *placeLabel;

@property (retain, nonatomic) IBOutlet UIImageView *placeBackgroudView;


@end
