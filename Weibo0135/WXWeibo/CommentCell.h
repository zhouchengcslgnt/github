//
//  CommentCell.h
//  WXWeibo
//
//  Created by 周城 on 14-4-29.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"

@class CommentModel;
@class BaseImageView;
@interface CommentCell : UITableViewCell <RTLabelDelegate>{
    BaseImageView *_userImageView;
    UILabel *_nickLabel;
    UILabel *_timeLabel;
    RTLabel *_contentLabel; 
    
}

@property(nonatomic,retain)CommentModel *commentModel;

+(float)getCommentHeight:(CommentModel *)commentModel;

@end
