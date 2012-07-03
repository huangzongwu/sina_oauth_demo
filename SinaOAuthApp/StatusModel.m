//
//  StatusModel.m
//  SinaOAuthApp
//
//  Created by 泽楷 郑 on 12-6-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StatusModel.h"
#import "OAuthFetcher.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"

@implementation StatusModel
@synthesize queue;
@synthesize delegate;


- (BOOL)updateWithString:(NSString *)status
{
    OAuthFetcher *fetcher = [OAuthFetcher getInstance];
    
    if (!fetcher.access_token) {
        return NO;
    }
    
    NSString *token = [fetcher access_token];
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/2/statuses/update.json"];

    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:token forKey:@"access_token"];
    [request setPostValue:status forKey:@"status"];
    [request startAsynchronous];
    return YES;
}


- (BOOL)startReflashAllStatus
{
    OAuthFetcher *fetcher = [OAuthFetcher getInstance];
    if (!fetcher.access_token) {
        return NO;
    }
    
    if (!self.queue) {
        [self setQueue:[[[NSOperationQueue alloc] init] autorelease]];
    }
    NSString *s_url = [NSString stringWithFormat:@"https://api.weibo.com/2/statuses/friends_timeline.json?access_token=%@&count=100", fetcher.access_token];
    
    NSURL *url = [NSURL URLWithString:s_url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    NSLog(@"status => 开始获取");
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestStatusDone:)];
    [self.queue addOperation:request];
    return YES;
}



#pragma mark - Process The request status

- (void)requestStatusDone:(ASIHTTPRequest *)req
{
    NSString *requestString = [[NSString alloc] initWithData:[req responseData]encoding:[req responseEncoding]];
    
    // 转成utf－8文字以后解析json
    // statuses 是数组
    NSArray *statuses = [[requestString objectFromJSONString] objectForKey:@"statuses"];
    NSMutableArray *texts = [[NSMutableArray alloc] initWithCapacity:50];
    NSLog(@"status => 完成获取");
    NSLog(@"status => 接收到 %d 条微薄", [statuses count]);
    
    for (NSDictionary *dic_status in statuses) {
        NSString *text = [dic_status objectForKey:@"text"];
        NSString *image_url = [[dic_status objectForKey:@"user"] objectForKey:@"profile_image_url"];
        
        NSURL *url = [NSURL URLWithString:image_url];
        __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        NSMutableDictionary *weibo = [NSMutableDictionary dictionaryWithCapacity:20];
        
        [request setCompletionBlock:^ {
            NSData *data = [request responseData];
            UIImage *image = [UIImage imageWithData:data];
            [weibo setObject:image forKey:@"image"];
            [self.delegate statusModel:self didFinishedLoadingwithTextArray:texts];
        }];
        [request setFailedBlock:^ {
            NSError *err = [request error];
            NSLog(@"%@", [err localizedDescription]);
        }];
        [weibo setObject:text forKey:@"text"];
        [texts addObject:weibo];
        [request startAsynchronous];
    }
    
    [self.delegate statusModel:self didFinishedLoadingwithTextArray:texts];
    [requestString release];
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}

@end
