//
//  WeiboViewController.m
//  SinaOAuthApp
//
//  Created by 泽楷 郑 on 12-6-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WeiboViewController.h"
#import "UpdateStatusController.h"
#import "ASIHTTPRequest.h"
@interface WeiboViewController ()

@end

@implementation WeiboViewController
@synthesize texts;
@synthesize model;
@synthesize reloading;
@synthesize refleshHeaderView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"首页"];
    
    // 设置左右button
    UIBarButtonItem *addNavigationButton = [[UIBarButtonItem alloc] 
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                            target:self 
                                            action:@selector(doUpdateStatus:)];
    
    UIBarButtonItem *reflashWeiboButton = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(doRefreshWeibo:)];
    
    [self.navigationItem setLeftBarButtonItem:addNavigationButton];
    [self.navigationItem setRightBarButtonItem:reflashWeiboButton];
    
    [addNavigationButton release];
    [reflashWeiboButton release];

    // 下拉刷新
    if (!refleshHeaderView) {
        EGORefreshTableHeaderView *refreshView = [[EGORefreshTableHeaderView alloc]  initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        
        [refreshView setDelegate:self];
        [self.tableView addSubview:refreshView];
        self.refleshHeaderView = refreshView;
        [refreshView release];
    }
    [refleshHeaderView setDelegate:self];
    [refleshHeaderView refreshLastUpdatedDate];
}

- (void)viewDidUnload
{
    model = nil;
    refleshHeaderView = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
    [model release];
    [refleshHeaderView release];
    [super dealloc];
}
#pragma mark - Button Actions
- (IBAction)doUpdateStatus:(id)sender
{
    UpdateStatusController *updateController = [[UpdateStatusController alloc] 
                                                initWithNibName:@"UpdateStatusController" 
                                                bundle:nil];
    
    [updateController setTitle:@"发布新微博"];
    [self.navigationController pushViewController:updateController animated:YES];
    [updateController release];
    
}

- (IBAction)doRefreshWeibo:(id)sender
{
    // 读取
    if (!model) {
        model = [[StatusModel alloc] init];
    }
    NSLog(@"设置委托");
    [self.model setDelegate:self];
    [self.model startReflashAllStatus];
}

- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    reloading = NO;
    [refleshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    
}

#pragma mark - UIScrollViewDelegate Method
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [refleshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [refleshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

#pragma mark - EGORefreshTableHeaderView Delegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    if (!model) {
        model = [[StatusModel alloc] init];
    }
    NSLog(@"设置委托");
    [self.model setDelegate:self];
    [self.model startReflashAllStatus];
    
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return self.reloading;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.texts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    NSDictionary *weibo = [self.texts objectAtIndex:indexPath.row];
    [[cell textLabel] setText:[weibo objectForKey:@"text"]];
    
    UIImage *image = [weibo objectForKey:@"image"];
    [cell.imageView setImage:image];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - StatusModel Delegate
- (void)statusModel:(StatusModel *)model didFinishedLoadingwithTextArray:(NSArray *)t
{
    [self setTexts:t];
    [self.tableView reloadData];
}
@end
