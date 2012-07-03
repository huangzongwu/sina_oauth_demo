//
//  WebViewController.h
//  TryAsiHttpRequest
//
//  Created by 泽楷 郑 on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WebViewControllerDelegate;
@interface WebViewController : UIViewController<UIWebViewDelegate>


- (id)initWithStringHtml:(NSString *)html andUrl:(NSURL *)url;

@property (assign, nonatomic) id<WebViewControllerDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIWebView *webview;
@property (retain, nonatomic) NSURL *currentUrl;
@property (retain, nonatomic) NSString *htmlStr;

@end

@protocol WebViewControllerDelegate <NSObject>

- (void)webViewController:(WebViewController *)controller didReceiveCode:(NSString *)code;

@end
