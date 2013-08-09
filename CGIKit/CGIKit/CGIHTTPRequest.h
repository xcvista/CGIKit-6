//
//  CGIHTTPRequest.h
//  CGIKit
//
//  Created by Maxthon Chan on 8/1/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MSBooster/MSBooster.h>

@interface CGIHTTPRequest : NSObject

@property NSDictionary *environemnt;
@property NSData *data;

@property (readonly) NSString *httpMethod;
@property (readonly) NSString *requestURI;
@property (readonly) NSString *protocol;

@property (readonly) NSDictionary *queryString;
@property (readonly) NSDictionary *form;

@property (readonly) NSUInteger contentLength;
@property (readonly) NSString *contentType;
@property (readonly) NSString *userAgent;

@end

#include <CGIKit/CGIHTTPRequestStrings.h>
