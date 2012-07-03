//
//  SinaUserInfo.m
//  SinaOAuthApp
//
//  Created by 泽楷 郑 on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SinaUserInfo.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
@implementation SinaUserInfo

- (id)initWithAccessToken:(NSString *)access_token andUserID:(NSString *)userid
{
    self = [super init];
    
    if (self) {
        _url = [NSString 
                stringWithFormat:@"https://api.weibo.com/2/users/show.json"
                                 @"?access_token=%@&uid=%@", 
                                 access_token,
                                 userid];
    }
    
    return self;
}

- (id)initwithJsonData:(NSDictionary *)jsonData
{
    self = [super init];
    if (self) {
        self.uid = [jsonData objectForKey:@"id"];
        self.name = [jsonData objectForKey:@"name"];
        self.location = [jsonData objectForKey:@"location"];
        self.description = [jsonData objectForKey:@"description"];
        self.gender = [jsonData objectForKey:@"gender"];
        self.followers_count = [jsonData objectForKey:@"followers_count"];
        self.friends_count = [jsonData objectForKey:@"friends_count"];
        self.statuses_count = [jsonData objectForKey:@"statuses_count"];
    }
    return self;
}

- (void)loadUserInfo
{
    NSURL *url = [NSURL URLWithString:_url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)dealloc
{
    [uid release];
    [name release];
    [location release];
    [description release];
    [gender release];
    [followers_count release];
    [friends_count release];
    [statuses_count release];
    [super dealloc];
}

#pragma mark - ASIHTTPRequestDelegate Methods
- (void)requestFailed:(ASIHTTPRequest *)request 
{
    NSError *err = [request error];
    NSLog(@"链接失败 => %@",[err localizedDescription]);
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *data = [request responseData];
    
    NSString *data_str = [[NSString alloc] 
                          initWithData:data 
                          encoding:[request responseEncoding]];
    
    // 获取json数据
    NSDictionary *jsonData = [data_str objectFromJSONString];
    
    self.uid = [jsonData objectForKey:@"id"];
    self.name = [jsonData objectForKey:@"name"];
    self.location = [jsonData objectForKey:@"location"];
    self.description = [jsonData objectForKey:@"description"];
    self.gender = [jsonData objectForKey:@"gender"];
    self.followers_count = [jsonData objectForKey:@"followers_count"];
    self.friends_count = [jsonData objectForKey:@"friends_count"];
    self.statuses_count = [jsonData objectForKey:@"statuses_count"];
    
    [self.delegate sinaUserInfoDidFinishedLoading:self];
    
}


@synthesize uid;
@synthesize name;
@synthesize location;
@synthesize description;
@synthesize gender;
@synthesize followers_count;
@synthesize friends_count;
@synthesize statuses_count;
@synthesize delegate;
@end
