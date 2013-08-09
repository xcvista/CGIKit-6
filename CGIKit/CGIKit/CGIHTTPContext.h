//
//  CGIHTTPContext.h
//  CGIKit
//
//  Created by Maxthon Chan on 8/1/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CGIHTTPRequest, CGIHTTPResponse;

@interface CGIHTTPContext : NSObject

@property (readonly) CGIHTTPRequest *request;
@property (readonly) CGIHTTPResponse *response;

- (id)initWithDisptachGroup:(dispatch_group_t)group;

- (void)run;

@end
