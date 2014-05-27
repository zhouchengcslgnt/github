//
//  WebDataService.m
//  WXWeibo
//
//  Created by 周城 on 14-5-16.
//  Copyright (c) 2014年 南京希曼技术. All rights reserved.
//

#import "WebDataService.h"

#define BASE_URL @"https://open.weibo.cn/2/"

@implementation WebDataService

+(ASIHTTPRequest *)requestWithURL:(NSString *)urlString params:(NSMutableDictionary *)params httpMethod:(NSString *)httpMethod completeBlock:(RequestFinishBlock)block
{
    //取得认证信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    NSString *accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
    
    //拼接Url 基础URL+认证
    urlString = [BASE_URL stringByAppendingFormat:@"%@?access_token=%@",urlString,accessToken];
    
    //处理GET请求
    NSComparisonResult *comparRet1 = [httpMethod caseInsensitiveCompare:@"GET"];
    if (comparRet1 == NSOrderedSame) {
        NSMutableString *paramsString = [NSMutableString string];
        NSArray *allKeys = [params allKeys];
        for (int i = 0; i<params.count; i++) {
            NSString *key = [allKeys objectAtIndex:i];
            id value = [params objectForKey:key];
            
            [paramsString appendFormat:@"%@=%@",key,value];
            
            if (i < params.count - 1) {
                [paramsString appendString:@"&"];
            }
        }
        
        //拼接URL +参数
        if (paramsString.length > 0 ) {
            urlString = [urlString stringByAppendingFormat:@"&%@",paramsString];
        }
        
    }

    
    NSURL *url = [NSURL URLWithString:urlString];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setTimeOutSeconds:60];//设置超时时间
    [request setRequestMethod:httpMethod];//设置请求方法post、get
    
    //处理POST请求
    NSComparisonResult *comparRet2 = [httpMethod caseInsensitiveCompare:@"POST"];
    if (comparRet2 == NSOrderedSame) {
        NSArray *allKeys = [params allKeys];
        for (int i = 0; i<params.count; i++) {
            NSString *key = [allKeys objectAtIndex:i];
            id value = [params objectForKey:key];
            
            //判断是否文件上传
            if ([value isKindOfClass:[NSData class]]) {
                [request addData:value forKey:key];
            }else{
                [request addPostValue:value forKey:key];
            }
        }
        
    }
    
    //设置请求完成的block
    [request setCompletionBlock:^{
        NSData *data = request.responseData;
        float version = WXHLOSVersion();
        id result = nil;
        if (version >= 5.0) {
            result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
        }else{
            result = [data objectFromJSONData];
        }
        
        //执行回调
        if (block != nil) {
            block(result);
        }
    }];
    
    //开始请求
    [request startAsynchronous];
    
    return request;
    
}
















@end
