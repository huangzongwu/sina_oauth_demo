//
//  WebViewController.m
//  TryAsiHttpRequest
//
//  Created by 泽楷 郑 on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"
#import "OAuthFetcher.h"
@interface WebViewController ()

@end

@implementation WebViewController
@synthesize webview;
@synthesize currentUrl;
@synthesize htmlStr;
@synthesize delegate;

- (id)initWithStringHtml:(NSString *)html andUrl:(NSURL *)url
{
    [self setHtmlStr:html];
    [self setCurrentUrl:url];
    return [self initWithNibName:@"WebViewController" bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.webview setDelegate:self];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"WebViewController : appear!");
    [self.webview loadHTMLString:self.htmlStr baseURL:self.currentUrl];
}

- (void)viewDidUnload
{
    [self setDelegate:nil];
    [self setHtmlStr:nil];
    [self setCurrentUrl:nil];
    [self setWebview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@", request.URL.host);
    if ([request.URL.host isEqualToString:@"kiddkai.github.com"]) {
        NSString *queryString = request.URL.query;
        NSRange range = [queryString rangeOfString:@"code="];
        NSString *code = [queryString substringFromIndex:range.length];

        // 调用委托方法
        [self.delegate webViewController:self didReceiveCode:code];
        
        [webview stopLoading];
        [self.navigationController popViewControllerAnimated:YES];
    }
    return YES;
}

- (void)dealloc {
    [self.htmlStr release];
    [self.currentUrl release];
    [webview release];
    [super dealloc];
}
@end
