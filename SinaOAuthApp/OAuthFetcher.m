//
//  OAuthFetcher.m
//  SinaOAuthApp
//
//  Created by 泽楷 郑 on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OAuthFetcher.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"

static OAuthFetcher *sharedFetcher;
@implementation OAuthFetcher

@synthesize webController;
@synthesize second;
@synthesize uid;
@synthesize code;
@synthesize access_token;
@synthesize queue;
@synthesize delegate;

+ (OAuthFetcher *)getInstance
{
    if (sharedFetcher == nil) {
        sharedFetcher = [[super allocWithZone:NULL] init];
    }
    return sharedFetcher;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [sharedFetcher retain];
}

+ (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)init 
{
    if (!self) {
        self = [super init];
    }    
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (void)release
{
    
}

- (id)autorelease
{
    return self;
}

#pragma mark - fetchers
- (void)fetchOAuthCode
{
    if (!self.queue) {
        [self setQueue:[[[NSOperationQueue alloc] init] autorelease]];
    }
    
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setPostValue:kAPP_KEY forKey:@"client_id"];
    [request setPostValue:kCALL_BACK_PAGE forKey:@"redirect_uri"];
    [request setPostValue:@"mobile" forKey:@"display"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(authorizeRequestDone:)];
    
    [self.queue addOperation:request];
}

- (void)fetchOAuthAccessToken
{
    if (!self.queue) {
        [self setQueue:[[[NSOperationQueue alloc] init] autorelease]];
    }
    
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/oauth2/access_token"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];

    [request setPostValue:kAPP_KEY forKey:@"client_id"];
    [request setPostValue:kAPP_SECRET forKey:@"client_secret"];
    [request setPostValue:@"authorization_code" forKey:@"grant_type"];
    [request setPostValue:self.code forKey:@"code"];
    [request setPostValue:kCALL_BACK_PAGE forKey:@"redirect_uri"];

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(accessTokenRequestDone:)];
    
    [self.queue addOperation:request];
}

#pragma mark - Requests Done Method
- (void)accessTokenRequestDone:(ASIHTTPRequest *)request
{
    
    NSString *str_data = [[NSString alloc] initWithData:[request responseData] 
                                               encoding:[request responseEncoding]];
    
    NSDictionary *data = [str_data objectFromJSONString];
    
    
    self.access_token = [data objectForKey:@"access_token"];
    self.uid = [data objectForKey:@"uid"];
    self.second = [[data objectForKey:@"expires_in"] intValue];
    [self.delegate oauthFetcherDidFinishedLoadingToken:self];
    [str_data release];
    
}

- (void)authorizeRequestDone:(ASIHTTPRequest *)request
{
    // 获取code字符串
    NSString *str_data = [[NSString alloc] initWithData:[request responseData] encoding:[request responseEncoding]];

    // 传入webController中

    [webController setHtmlStr:str_data];
    [webController setCurrentUrl:[request url]];
    [webController setDelegate:self];
    

    [self.delegate oauthFetcherDidFinishedLoadingPage:self];
    [str_data release];
    
}

#pragma mark - WebViewController Delegate Methods
- (void)webViewController:(WebViewController *)controller didReceiveCode:(NSString *)c
{
    self.code = c;
    [self.delegate oauthFetcherDidFinishedLoadingCode:self];
}


@end
