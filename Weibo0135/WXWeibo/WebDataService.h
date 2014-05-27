//
//  WebDataService.h
//  WXWeibo
//
//  Created by 周城 on 14-5-16.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

typedef void(^RequestFinishBlock)(id result);

@interface WebDataService : NSObject

+(ASIHTTPRequest *)requestWithURL:(NSString *)urlString params:(NSMutableDictionary *)params httpMethod:(NSString *)httpMethod completeBlock:(RequestFinishBlock)block ;

@end
