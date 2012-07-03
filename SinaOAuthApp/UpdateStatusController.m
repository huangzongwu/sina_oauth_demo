//
//  UpdateStatusController.m
//  SinaOAuthApp
//
//  Created by 泽楷 郑 on 12-6-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UpdateStatusController.h"
#import "StatusModel.h"
@interface UpdateStatusController ()

@end

@implementation UpdateStatusController
@synthesize updateText;

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
}

- (void)viewDidUnload
{
    [self setUpdateText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [updateText release];
    [super dealloc];
}

- (IBAction)doUpdate:(id)sender {
    StatusModel *status = [[StatusModel alloc] init];
    
    [status updateWithString:self.updateText.text];
    [status release];
}



@end


















