//
//  SinaUserInfo.h
//  SinaOAuthApp
//
//  Created by 泽楷 郑 on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"

@protocol SinaUserInfoDelegate;
@interface SinaUserInfo : NSObject<ASIHTTPRequestDelegate>
{
    NSString *_url;
}

- (id)initWithAccessToken:(NSString *)access_token andUserID:(NSString *)userid;
- (void)loadUserInfo;

- (id)initwithJsonData:(NSDictionary *)jsonData;

@property (nonatomic, retain) NSNumber *uid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, retain) NSNumber *followers_count;
@property (nonatomic, retain) NSNumber *friends_count;
@property (nonatomic, retain) NSNumber *statuses_count;
@property (assign, nonatomic) id<SinaUserInfoDelegate> delegate;

@end


@protocol SinaUserInfoDelegate <NSObject>

- (void)sinaUserInfoDidFinishedLoading:(SinaUserInfo *)info;
@end