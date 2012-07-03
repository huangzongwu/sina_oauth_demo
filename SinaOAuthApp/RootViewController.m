//
//  RootViewController.m
//  SinaOAuthApp
//
//  Created by 泽楷 郑 on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "WebViewController.h"
#import "OAuthFetcher.h"
#import "UpdateStatusController.h"

@interface RootViewController ()

@end

@implementation RootViewController

@synthesize fetcher;
@synthesize webController;
@synthesize nameField;
@synthesize locationField;
@synthesize genderField;
@synthesize followsField;
@synthesize friendsField;
@synthesize statCountFirld;
@synthesize userinfo;

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
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"认证页面"];
}

- (void)viewDidUnload
{
    [self setNameField:nil];
    [self setLocationField:nil];
    [self setGenderField:nil];
    [self setFollowsField:nil];
    [self setFriendsField:nil];
    [self setStatCountFirld:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [webController release];
    [fetcher release];

    [nameField release];
    [locationField release];
    [genderField release];
    [followsField release];
    [friendsField release];
    [statCountFirld release];
    [super dealloc];
}


- (IBAction)popAndSendWeibo:(id)sender {
    UpdateStatusController *updateController = [[UpdateStatusController alloc] initWithNibName:@"UpdateStatusController" bundle:nil];
    
    [self.navigationController pushViewController:updateController animated:YES];
    
    [updateController release];
}


#pragma mark - OAuth
- (IBAction)doOAuth:(id)sender {
    
    if (!self.webController)
        self.webController = [[WebViewController alloc] init];
    
    self.fetcher = [OAuthFetcher getInstance];
    
    [fetcher setDelegate:self];
    [fetcher setWebController:webController];
    [fetcher fetchOAuthCode];

}

#pragma mark - OAuth Fetcher Delegate
- (void)oauthFetcherDidFinishedLoadingPage:(OAuthFetcher *)f
{
    [self.navigationController pushViewController:webController animated:YES];
}

- (void)oauthFetcherDidFinishedLoadingCode:(OAuthFetcher *)f
{
    [self.fetcher fetchOAuthAccessToken];
}

- (void)oauthFetcherDidFinishedLoadingToken:(OAuthFetcher *)f
{

    NSLog(@"%@ => %@", [self.fetcher access_token], [self.fetcher uid]);
    if (!self.userinfo) {
        self.userinfo = [[SinaUserInfo alloc] 
                         initWithAccessToken:self.fetcher.access_token 
                         andUserID:self.fetcher.uid];
    }
    
    [self.userinfo setDelegate:self];
    [self.userinfo loadUserInfo];
}

#pragma mark - SinaUserInfo Delegate
- (void)sinaUserInfoDidFinishedLoading:(SinaUserInfo *)i
{
    self.nameField.text = i.name;
    self.locationField.text = i.location;
    self.genderField.text = i.gender;
    self.followsField.text = [NSString stringWithFormat:@"%@",i.followers_count];
    self.friendsField.text = [NSString stringWithFormat:@"%@",i.friends_count];
    self.statCountFirld.text = [NSString stringWithFormat:@"%@", i.statuses_count];
}
@end


























