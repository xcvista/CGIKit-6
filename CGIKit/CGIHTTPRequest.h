//
//  CGIHTTPRequest.h
//  CGIKit
//
//  Created by Maxthon Chan on 8/1/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MSBooster/MSBooster.h>

/**
 @brief     The object encapsulates the request of an HTTP context.
 
 The CGIHTTPRequest object encapsulates the FastCGI request from the server.
 */
@interface CGIHTTPRequest : NSObject

/**
 @name      FastCGI protocol
 */

/**
 @brief     Environment variables.
 
 FastCGI server passes all HTTP request header information in environment
 variables.
 
 @note      To get the current environment variables, use -[NSProcessInfo
            environment] instead.
 */
@property NSDictionary *environemnt;

/**
 POST data.
 
 @note      If there is no POST data, this variable will be a zero-length NSData
            object.
 */
@property NSData *data;

/**
 @name      Convenience methods
 */

/// HTTP methods.
@property (readonly) NSString *httpMethod;
/// Requested URI.
@property (readonly) NSString *requestURI;
/// Protocol (e.g HTTP/1.1).
@property (readonly) NSString *protocol;

/// Parsed query string.
@property (readonly) NSDictionary *queryString;
/// Parsed POST form.
@property (readonly) NSDictionary *form;

/// User agent of the client.
@property (readonly) NSString *userAgent;
/// Length of the POST content.
@property (readonly) NSInteger contentLength;

@end

#include <CGIKit/CGIHTTPRequestStrings.h>
