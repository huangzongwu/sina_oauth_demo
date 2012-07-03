//
//  RootViewController.h
//  SinaOAuthApp
//
//  Created by 泽楷 郑 on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OAuthFetcher.h"
#import "SinaUserInfo.h"
@class WebViewController;


@interface RootViewController : UIViewController<OAuthFetcherDelegate, SinaUserInfoDelegate>

@property (retain, nonatomic) SinaUserInfo *userinfo;
@property (retain, nonatomic) OAuthFetcher *fetcher;
@property (retain, nonatomic) WebViewController *webController;



@property (retain, nonatomic) IBOutlet UITextField *nameField;
@property (retain, nonatomic) IBOutlet UITextField *locationField;
@property (retain, nonatomic) IBOutlet UITextField *genderField;
@property (retain, nonatomic) IBOutlet UITextField *followsField;
@property (retain, nonatomic) IBOutlet UITextField *friendsField;
@property (retain, nonatomic) IBOutlet UITextField *statCountFirld;


@end
