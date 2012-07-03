//
//  OAuthFetcher.h
//  SinaOAuthApp
//
//  Created by 泽楷 郑 on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebViewController.h"

#define kAPP_KEY           @"1888308901"
#define kAPP_SECRET        @"b6d45a83f2ba9827ffa92766289461f8"
#define kCALL_BACK_PAGE    @"http://kiddkai.github.com"
#define kAUTHORIZE_URL     @"https://api.weibo.com/oauth2/authorize"

@protocol OAuthFetcherDelegate ;
@interface OAuthFetcher : NSObject<WebViewControllerDelegate>

@property (retain, nonatomic) NSOperationQueue *queue;
@property (retain, nonatomic) WebViewController *webController;
@property (assign, nonatomic) id<OAuthFetcherDelegate> delegate;

@property (retain, nonatomic) NSString *code;
@property (retain, nonatomic) NSString *access_token;
@property (retain, nonatomic) NSString *uid;
@property (nonatomic) NSInteger second;


+ (OAuthFetcher *)getInstance;

- (void)fetchOAuthCode;
- (void)fetchOAuthAccessToken;

@end


@protocol OAuthFetcherDelegate <NSObject>

- (void)oauthFetcherDidFinishedLoadingPage:(OAuthFetcher *)fetcher;
- (void)oauthFetcherDidFinishedLoadingCode:(OAuthFetcher *)fetcher;
- (void)oauthFetcherDidFinishedLoadingToken:(OAuthFetcher *)fetcher;

@end