//
//  CGIHTTPContext.h
//  CGIKit
//
//  Created by Maxthon Chan on 8/1/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <CGIKit/CGIApplication.h>

@class CGIHTTPRequest, CGIHTTPResponse;

/**
 Delegate of the HTTP context.
 
 ## Application delegate or Context delegate?
 
 Generally speaking, you should use context delegate for a single session, while
 reserve the application delegate for Application-wide state and management.
 Future support of FastCGI filters and authenticators will not be supported by
 application delegates, only by context delegates. For the trivialest kind of
 application, you may use the application delegate to handle both sessions and
 application states.
 
 Context delegates are guaranteed to be called within the same dispatch queue,
 however application delegate may be called by multiple queues and threads
 except applicationDidFinishLaunching:, createDelegateForContext: and
 applicationWillTerminate:.
 
 @note      All methods in this protocol should respect the timeout requirements
            of the FastCGI protocol, the HTTP server and the HTTP client.
 */
@protocol CGIHTTPContextDelegate <NSObject>

@optional

/**
 @name      Context Lifecycle
 */

/**
 Called when the context received a request. You can reject a request with this
 method, and a rejected request will be responded with HTTP 501 Not Implemented
 response. Also, you should set up environemnt of handling the request in this 
 method.
 
 @param     context             The context object that sent this delegate
                                message.
 @param     request             The request to be handled.
 @return    Whether the input should be handled. You can reject the request by
            returning NO.
 */
- (BOOL)context:(CGIHTTPContext *)context shouldHandleRequest:(CGIHTTPRequest *)request;

/**
 Called to handle the HTTP request and generate the response.
 
 @param     context             The HTTP context to be handled.
 */
- (void)handleHTTPContext:(CGIHTTPContext *)context;

/**
 Called when an application is going to send a response. You can redact a
 response by returning NO from this method, and a redacted response will be
 replaced with a HTTP 403 Forbidden response.
 
 @param     context             The context object that sent this delegate
                                message.
 @param     response            The response to be handled.
 @return    Whether the response should be sent. Return NO to redact the
            response.
 */
- (BOOL)context:(CGIHTTPContext *)context shouldSendResponse:(CGIHTTPResponse *)response;

/**
 Called when an application finished sending a response.
 
 @param     context             The context object that sent this delegate
                                message.
 @param     response            The response to be handled.
 */
- (void)context:(CGIHTTPContext *)context didSendResponse:(CGIHTTPResponse *)response;

@end

@interface CGIHTTPContext : NSObject

@property id<CGIHTTPContextDelegate> delegate;
@property (readonly) CGIHTTPRequest *request;
@property (readonly) CGIHTTPResponse *response;

- (id)initWithDisptachGroup:(dispatch_group_t)group delegate:(id<CGIHTTPContextDelegate>)delegate;

- (void)run;

- (BOOL)contextShouldHandleRequest:(CGIHTTPRequest *)request;
- (void)handleHTTPContext;
- (BOOL)contextShouldSendResponse:(CGIHTTPResponse *)response;
- (void)contextDidSendResponse:(CGIHTTPResponse *)response;

@end
