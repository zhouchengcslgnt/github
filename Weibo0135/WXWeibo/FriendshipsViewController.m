//
//  FriendshipsViewController.m
//  WXWeibo
//
//  Created by 周城 on 14-5-22.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "FriendshipsViewController.h"
#import "WebDataService.h"
#import "UserModel.h"
#import "FriendShipsTableView.h"

@interface FriendshipsViewController ()

@end

@implementation FriendshipsViewController

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
    self.data = [NSMutableArray array];//初始化数组
    [self loadAtData];
}

-(void)loadAtData
{
    if (self.userID.length == 0) {
        NSLog(@"用户ID为空");
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.userID forKey:@"uid"];
    
    [WebDataService requestWithURL:@"friendships/friends.json" params:params httpMethod:@"GET" completeBlock:^(id result) {
        [self loadAtDataFinish:result];
    }];
}

-(void)loadAtDataFinish:(id)result
{
    
    NSArray *usersArray = [result objectForKey:@"users"];
    if (usersArray.count == 0) {
        return;
    }
    
    NSMutableArray *array2D = nil;
    for (int i = 0; i <usersArray.count; i++) {
        if (i % 3 == 0) {
            array2D = [NSMutableArray arrayWithCapacity:3];
            [self.data addObject:array2D];
        }
        NSDictionary *userDic = [usersArray objectAtIndex:i];
        UserModel *userModel = [[UserModel alloc] initWithDataDic:userDic];
        [array2D addObject:userModel];
        [userModel release];
    }
    
    self.tableView.data = self.data;
    [self.tableView reloadData];
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
