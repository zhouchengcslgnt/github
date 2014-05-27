//
//  CommentTableView.m
//  WXWeibo
//
//  Created by 周城 on 14-4-29.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "CommentTableView.h"
#import "CommentCell.h"
#import "CommentModel.h"

@implementation CommentTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"CommentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil] lastObject];
    }
    
    CommentModel *commentModel = [self.data objectAtIndex:indexPath.row];
    cell.commentModel = commentModel;
    
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentModel *commentModel = [self.data objectAtIndex:indexPath.row];
    float h = [CommentCell getCommentHeight:commentModel];
    return h + 21 + 15;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *commentCount = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
    commentCount.backgroundColor = [UIColor clearColor];
    commentCount.font = [UIFont boldSystemFontOfSize:13.0f];
    commentCount.textColor = [UIColor blueColor];
    
    NSNumber *total = [self.commentDic objectForKey:@"total_number"];
    commentCount.text = [NSString stringWithFormat:@"评论:%@",total];
    [view addSubview:commentCount];
    [commentCount release];
    
    UIImageView *separeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userinfo_header_separator.png"]];
    separeView.frame = CGRectMake(0, 25, tableView.width, 1);
    [view addSubview:separeView];
    [separeView release];
    
    return [view autorelease];
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
