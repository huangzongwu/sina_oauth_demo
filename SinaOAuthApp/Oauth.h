//
//  Oauth.h
//  SinaOAuthApp
//
//  Created by 泽楷 郑 on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Oauth : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * access_token;

@end
