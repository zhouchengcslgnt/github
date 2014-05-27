//
//  RightViewController.m
//  WXWeibo
//
//  Created by 周城 on 14-5-6.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "RightViewController.h"
#import "SendViewController.h"
#import "BaseNavigationController.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendAction:(UIButton *)sender {
    if (sender.tag == 10) {
        SendViewController *sendCtrl = [[SendViewController alloc] init];
        BaseNavigationController *sendNav = [[BaseNavigationController alloc] initWithRootViewController:sendCtrl];
        [self.appDelegate.menuCtrl presentViewController:sendNav animated:YES completion:nil];
        [sendCtrl release];
        [sendNav release];
        
    }else if (sender.tag == 11){
        
    }else if (sender.tag == 12){
        
    }else if (sender.tag == 13){
        
    }else if (sender.tag == 14){
        
    }

}





@end
