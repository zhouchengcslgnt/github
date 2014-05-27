//
//  DiscoverViewController.m
//  WXWeibo
//
//  Created by wei.chen on 13-1-21.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "DiscoverViewController.h"
#import "NearWeiBoMapViewController.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"广场";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NearWeiBoMapViewController *near = [[NearWeiBoMapViewController alloc] init];
    [self.navigationController pushViewController:near animated:YES];
    [near release];
    
}



@end
