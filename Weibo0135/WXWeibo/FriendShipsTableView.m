//
//  FriendShipsTableView.m
//  WXWeibo
//
//  Created by 周城 on 14-5-22.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "FriendShipsTableView.h"
#import "FriendShipsCell.h"

@implementation FriendShipsTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"FriendShipsCell";
    FriendShipsCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[FriendShipsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //取数据 给 cell
    NSArray *array = [self.data objectAtIndex:indexPath.row];
    cell.data = array;
    
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}


@end
