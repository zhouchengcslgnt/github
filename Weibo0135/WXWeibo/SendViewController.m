//
//  SendViewController.m
//  WXWeibo
//
//  Created by 周城 on 14-5-6.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "SendViewController.h"
#import "UIFactory.h"
#import "ThemeButton.h"
#import "NearbyViewController.h"
#import "BaseNavigationController.h"
#import "BaseImageView.h"
#import "MainImageScrollViews.h"
#import "WebDataService.h"
#import "FaceScrollView.h"

@interface SendViewController ()

@end

@implementation SendViewController

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
    [_textView release];
    [_editorBar release];
    [_placeView release];
    [_placeLabel release];
    [_placeBackgroudView release];
    [_scrollView release];
    [_faceView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillShowAction:) name:UIKeyboardWillShowNotification object:nil];
        
        //
        self.isCacelButton = YES;
        self.isBackButton = NO;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发布微博";
    
    //初始化按钮数组
    _buttons = [[NSMutableArray alloc] initWithCapacity:6];
    [self _initView];
    
    //创建导航按钮
    ThemeButton *sendButton = [UIFactory createNavigationButton:CGRectMake(0, 0, 45, 30) title:@"发布" target:self action:@selector(sendAction)];
    UIBarButtonItem *sendButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    self.navigationItem.rightBarButtonItem = [sendButtonItem autorelease];
}

//发布微博
-(void)doSendData
{
    NSString *text = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];//去掉前后空格
    
    if (text.length == 0) {
        NSLog(@"微博内容为空");
        return;
    }
    
    [self showStatusTip:YES title:@"正在发送..."];
    
    //设置参数
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:text forKey:@"status"];
    if (self.longitude.length > 0) {
        [params setObject:self.longitude forKey:@"long"];
    }
    if (self.latitude.length > 0) {
        [params setObject:self.latitude forKey:@"lat"];
    }
    
    if (self.sendImage == nil) {
        //不带图片的
        [self.sinaweibo requestWithURL:@"statuses/update.json" params:params httpMethod:@"POST" block:^(id result){
            [self cancleAction];//成功后退出界面
            [self showStatusTip:NO title:@"发送成功"];
        }];
    }else{
        //带图片的
        NSData *data = UIImageJPEGRepresentation(self.sendImage, 0.3);//压缩图片，转成data 二进制
        [params setObject:data forKey:@"pic"];
        
//        [self.sinaweibo requestWithURL:@"statuses/upload.json" params:params httpMethod:@"POST" block:^(id result){
//            [self cancleAction];//成功后退出界面
//            [self showStatusTip:NO title:@"发送成功"];
//        }];
        
        //自己封装的AS网络请求
        [WebDataService requestWithURL:@"statuses/upload.json" params:params httpMethod:@"POST" completeBlock:^(id result){
              [self cancleAction];//成功后退出界面
              [self showStatusTip:NO title:@"发送成功"];
        }];

    }
    
    
}

-(void)_initView
{
    NSArray *imageNames = [NSArray arrayWithObjects:
                           @"compose_locatebutton_background.png",
                           @"compose_camerabutton_background.png",
                           @"compose_trendbutton_background.png",
                           @"compose_mentionbutton_background.png",
                           @"compose_emoticonbutton_background.png",
                           @"compose_keyboardbutton_background.png",
                           nil];
    
    NSArray *imageHighteds = [NSArray arrayWithObjects:
                             @"compose_locatebutton_background_highlighted.png",
                             @"compose_camerabutton_background_highlighted.png",
                             @"compose_trendbutton_background_highlighted.png",
                             @"compose_mentionbutton_background_highlighted.png",
                             @"compose_emoticonbutton_background_highlighted.png",
                             @"compose_keyboardbutton_background_highlighted.png",
                             nil];
    
    for (int i = 0; i < imageNames.count; i++) {
        NSString *imageName = [imageNames objectAtIndex:i];
        NSString *imageHighted = [imageHighteds objectAtIndex:i];
        ThemeButton *button = [UIFactory createButton:imageName highlighted:imageHighted];
        button.tag = (10+i);
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(20+(64*i), 26, 23, 19);
        
        [_buttons addObject:button];
        [_editorBar addSubview:button];
        
        //键盘按钮先隐藏
        if (i == 5) {
            button.hidden = YES;
            button.left -= 64;
        }
    }
    
    //初始化地址显示
    UIImage *image = [self.placeBackgroudView.image stretchableImageWithLeftCapWidth:30 topCapHeight:0];//设置拉伸的位置
    self.placeBackgroudView.image = image;
    self.placeBackgroudView.width = ScreenWidth;
    self.placeBackgroudView.backgroundColor = [UIColor clearColor];
    
    self.placeLabel.left = 30;
    self.placeLabel.width = ScreenWidth - 40;
    
    [self.textView becomeFirstResponder];
    self.textView.delegate = self;
}

-(void)location
{
    NearbyViewController *nearby = [[NearbyViewController alloc] init];
    BaseNavigationController *nearbyNav = [[BaseNavigationController alloc]initWithRootViewController:nearby];
    [self presentViewController:nearbyNav animated:YES completion:nil];
    [nearby release];
    [nearbyNav release];
    
    nearby.selectBlock = ^(NSDictionary *result){
        //记录位置坐标
        self.latitude = [result objectForKey:@"lat"];
        self.longitude = [result objectForKey:@"lon"];
        
        NSString *address = [result objectForKey:@"address"];
        if ([address isKindOfClass:[NSNull class]] || address.length == 0) {
            address = [result objectForKey:@"title"];
        }
        _placeLabel.text = address;
        _placeView.hidden = NO;
        
        //设置成选中
        ThemeButton *locationButton = [_buttons objectAtIndex:0];
        locationButton.highlighted = YES;
    };
    
}

//使用相片
-(void)selectImage
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"用户相册", nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
    
}


-(void)showFaceView
{
    [self.textView resignFirstResponder];
    
    if (_faceView == nil) {
        _faceView = [[FaceScrollView alloc] initWithFrame:CGRectZero];
        _faceView.top = ScreenHeight -20-44-_faceView.height;
        _faceView.transform = CGAffineTransformTranslate(_faceView.transform, 0, ScreenHeight-44-20);
        __block SendViewController *this = self;
        _faceView.selectFaceViewBlock = ^(NSString *faceName){
            NSString *text = this.textView.text;
            this.textView.text = [text stringByAppendingString:faceName];
        };
        
        [self.view addSubview:_faceView];
        [_faceView release];
    }
    UIButton *faceButton = [_buttons objectAtIndex:4];
    UIButton *keyboard = [_buttons objectAtIndex:5];
    faceButton.alpha = 1;//不透明
    keyboard.alpha = 0;//全透明
    keyboard.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _faceView.transform = CGAffineTransformIdentity;
        faceButton.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            keyboard.alpha = 1;
        }];
    }];
    
    //调整textView，editorBar的坐标
    self.editorBar.bottom = ScreenHeight-20-44-_faceView.height;
    self.textView.height = self.editorBar.top;
}

-(void)showKeyboard
{
    [self.textView becomeFirstResponder];//获得焦点
    
    UIButton *faceButton = [_buttons objectAtIndex:4];
    UIButton *keyboard = [_buttons objectAtIndex:5];
    faceButton.alpha = 0;//不透明
    keyboard.alpha = 1;//全透明
    
    [UIView animateWithDuration:0.3 animations:^{
        _faceView.transform = CGAffineTransformTranslate(_faceView.transform, 0, ScreenHeight-44-20);
         keyboard.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            faceButton.alpha = 1;
        }];
    }];
}

#pragma mark - action
-(void)cancleAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendAction
{
    //
    [self doSendData];
}

-(void)buttonAction:(ThemeButton *)button
{
    if (button.tag == 10) {
        //地理位置
        [self location];
    }
    else if (button.tag == 11){
        //选择图片
        [self selectImage];
        
    }else if (button.tag == 12){
        //
        
    }else if (button.tag == 13){
        
    }else if (button.tag == 14){
        //选择表情
        [self showFaceView];
        
    }else if (button.tag == 15){
        //选择键盘
        [self showKeyboard];
        
    }
}

//全屏放大图片
-(void)imageAction
{
    //ImageView的创建
    if (_scrollView == nil) {
        
        _scrollView = [[[MainImageScrollViews alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)] autorelease];
        _scrollView.touchBlock = ^{
            [self scaleImageAction:nil];
        };
        _scrollView.deleteButtonBlock = ^(UIButton *button){
            //删除按钮
            [self deleteAtion:button];
            
        };
        
    }
    //图片数组
    NSMutableArray *images = [[[NSMutableArray alloc] init] autorelease];
    [images addObject:_sendImage];
    [images addObject:_sendImage];//测试
    _scrollView.images = images;
    
    [self.textView resignFirstResponder];//取消焦点使键盘隐藏
    
    //判断是否有superview，没有的话就添加上去
    if (![_scrollView superview]) {
        
        [self.view.window addSubview:_scrollView];
        
        //加个放大的动画效果
        _scrollView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);//初始放大的位置
        [UIView animateWithDuration:0.4 animations:^{
            _scrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            
        } completion:^(BOOL finished){
            [UIApplication sharedApplication].statusBarHidden = YES;//状态栏的隐藏
        }];
    }
    
}

//点击输小图片
-(void)scaleImageAction:(UITapGestureRecognizer *)tap
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIView animateWithDuration:0.4 animations:^{
        _scrollView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
    } completion:^(BOOL finished) {
        [_scrollView removeFromSuperview];
    }];
}

-(void)deleteAtion:(UIButton *)button
{
    [self scaleImageAction:nil];//缩小图片
    //移除缩放图
    [self.sendImageView removeFromSuperview];
    self.sendImage = nil;
    
    //按钮向右移动
    ThemeButton *button1 = [_buttons objectAtIndex:0];
    ThemeButton *button2 = [_buttons objectAtIndex:1];
    ThemeButton *button3 = [_buttons objectAtIndex:2];
    ThemeButton *button4 = [_buttons objectAtIndex:3];
    //动画
    [UIView animateWithDuration:0.5 animations:^{
        button1.transform = CGAffineTransformIdentity;
        button2.transform = CGAffineTransformIdentity;
        button3.transform = CGAffineTransformIdentity;
        button4.transform = CGAffineTransformIdentity;
    }];

}

//键盘show
-(void)KeyboardWillShowAction:(NSNotification *)notification
{
   // NSLog(@"%@",notification.userInfo);
    NSValue *keyboardValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [keyboardValue CGRectValue];
    float height = frame.size.height;
    
    self.editorBar.bottom = ScreenHeight-height-20-44;//要减状态栏和导航栏的高度
    self.textView.height = self.editorBar.top;
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerControllerSourceType sourceType;
    
    if (buttonIndex == 0) {
        //判断下是否有摄像头
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此设备没有摄像头" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
            return;
        }
        //拍照
        sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }else if (buttonIndex == 1){
        //用户相册
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }else if (buttonIndex == 2){
        //取消
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
    //返回
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.sendImage = image;
    
    if (self.sendImageView == nil) {
        BaseImageView *sendImageView = [[BaseImageView alloc] init];
        sendImageView.layer.cornerRadius = 5;//设置弧度
        sendImageView.layer.masksToBounds = 5;
        sendImageView.frame = CGRectMake(5, 20, 25, 25);
        //图片的点击事件
        sendImageView.touchBlock = ^{
            [self imageAction];
        };
        
        self.sendImageView = sendImageView;
    }

    self.sendImageView.image = image;
    [self.editorBar addSubview:self.sendImageView];
    
    //按钮向右移动
    ThemeButton *button1 = [_buttons objectAtIndex:0];
    ThemeButton *button2 = [_buttons objectAtIndex:1];
    ThemeButton *button3 = [_buttons objectAtIndex:2];
    ThemeButton *button4 = [_buttons objectAtIndex:3];
    //动画
    [UIView animateWithDuration:0.5 animations:^{
        button1.transform = CGAffineTransformIdentity;
        button2.transform = CGAffineTransformIdentity;
        button3.transform = CGAffineTransformIdentity;
        button4.transform = CGAffineTransformIdentity;
        
        button1.transform = CGAffineTransformTranslate(button1.transform, 30, 0);
        button2.transform = CGAffineTransformTranslate(button2.transform, 20, 0);
        button3.transform = CGAffineTransformTranslate(button3.transform, 15, 0);
        button4.transform = CGAffineTransformTranslate(button4.transform, 10, 0);
        
    }];

    //返回
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextViewDelegate
//开始编辑时调用
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self showKeyboard];
    return YES;
}

@end
