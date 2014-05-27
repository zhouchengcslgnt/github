//
//  FriendShipsCell.m
//  WXWeibo
//
//  Created by 周城 on 14-5-22.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "FriendShipsCell.h"
#import "UserGridView.h"
#import "UserModel.h"

@implementation FriendShipsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

-(void)initViews
{
    for (int i=0; i<3; i++) {
        UserGridView *gridView = [[UserGridView alloc] initWithFrame:CGRectZero];
        gridView.tag = 100+i;
        [self.contentView addSubview:gridView];
        [gridView release];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i<self.data.count; i++) {
        UserModel *userModel = [self.data objectAtIndex:i];
        int tag = 100+i;
        UserGridView *gridView = (UserGridView *)[self.contentView viewWithTag:tag];
        gridView.userModel = userModel;
        gridView.frame = CGRectMake(100*i, 10, 96, 96);
    }
}

@end
