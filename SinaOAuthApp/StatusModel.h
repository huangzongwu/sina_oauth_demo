//
//  StatusModel.h
//  SinaOAuthApp
//
//  Created by 泽楷 郑 on 12-6-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol StatusModelDelegate;
@interface StatusModel : NSObject

@property (nonatomic, retain) NSOperationQueue *queue;
@property (nonatomic, assign) id<StatusModelDelegate> delegate;

- (BOOL)updateWithString: (NSString *)status;
- (BOOL)startReflashAllStatus;

@end

@protocol StatusModelDelegate <NSObject>

@optional
- (void)statusModel:(StatusModel *)model didFinishedLoadingwithTextArray:(NSArray *)texts;

@end