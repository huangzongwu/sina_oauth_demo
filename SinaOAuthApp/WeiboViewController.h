//
//  WeiboViewController.h
//  SinaOAuthApp
//
//  Created by 泽楷 郑 on 12-6-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusModel.h"
#import "EGOTableViewPullRefresh/Classes/View/EGORefreshTableHeaderView.h"

@interface WeiboViewController : UITableViewController<StatusModelDelegate, 
    EGORefreshTableHeaderDelegate, UIScrollViewDelegate>

@property (nonatomic, retain) EGORefreshTableHeaderView *refleshHeaderView;
@property (nonatomic) BOOL reloading;
@property (nonatomic, retain) NSArray *texts;
@property (nonatomic, retain) StatusModel *model;
- (void)doneLoadingTableViewData;
@end
