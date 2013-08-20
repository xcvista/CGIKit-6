//
//  CGIApplication.h
//  CGIKit
//
//  Created by Maxthon Chan on 7/31/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#ifndef CGIKit_CGIApplication_h
#define CGIKit_CGIApplication_h

#include <MSBooster/MSBooster.h>

__BEGIN_DECLS

__class CGIApplication;
__class CGIHTTPRequest;
__class CGIHTTPResponse;
__class CGIHTTPContext;

/**
 Main entry point of an CGI Application.
 
 @param     argc                Number of arguments passed to main()
 @param     argv                Argument vector passed to main()
 @param     applicationClass    Name of class of the application. Default to
                                CGIApplication.
 @param     delegateClass       Name of class of the application delegate.
 @return    This method does not return despite the int return type.
 */
extern int MSNoReturn CGIApplicationMain(int argc,
                                         const char **argv,
                                         NSString *applicationClass,
                                         NSString *delegateClass);

/**
 Shared instance of current CGIApplication.
 
 @see       +[CGIApplication sharedApplication]
 */
extern id CGIApp;

MSConstantString(CGIApplicationName, CGIApplication);

#if __OBJC__

@protocol CGIHTTPContextDelegate;

/**
 Application delegate for the Web application.
 
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
@protocol CGIApplicationDelegate <NSObject>

@optional

/**
 @name      Application Lifecycle
 */

/**
 @brief     Called when the application did finished launching.
 
 You should finish app-specific initialization in this method.
 
 @param     application         The application object that sent this delegate
                                message.
 */
- (void)applicationDidFinishLaunching:(CGIApplication *)application;

/**
 @brief     Called when an application received a request.
 
 You can reject a request with this method, and a rejected request will be
 responded with HTTP 501 Not Implemented response. Also, you should set up
 environemnt of handling the request in this method.
 
 Alternatively, you can instantiate a contenxt delegate
 in this method and assign it to the context based on the request data.
 
 @note      This method is expected to be thread-safe. It could be overridden by
            the delegate of the context.
 
 @param     application         The application object that sent this delegate
                                message.
 @param     request             The request to be handled.
 @return    Whether the input should be handled. You can reject the request by
            returning NO.
 */
- (BOOL)application:(CGIApplication *)application
shouldHandleRequest:(CGIHTTPRequest *)request;

/**
 Called to handle the HTTP request and generate the response.
 
 @note      This method is expected to be thread-safe. It could be overridden by
            the delegate of the context.
 
 @param     application         The application object that sent this delegate
            message.
 @param     context             The HTTP context to be handled.
 */
- (void)application:(CGIApplication *)application
  handleHTTPContext:(CGIHTTPContext *)context;

/**
 @brief     Called when an application is going to send a response.
 
 You can redact a response by returning NO from this method, and a redacted
 response will be replaced with a HTTP 403 Forbidden response.
 
 @note      This method is expected to be thread-safe. It could be overridden by
            the delegate of the context.
 
 @param     application         The application object that sent this delegate
                                message.
 @param     response            The response to be handled.
 @return    Whether the response should be sent. Return NO to redact the 
            response.
 */
- (BOOL)application:(CGIApplication *)application
 shouldSendResponse:(CGIHTTPResponse *)response;

/**
 Called when an application finished sending a response.
 
 @note      This method is expected to be thread-safe. It could be overridden by
            the delegate of the context.
 
 @param     application         The application object that sent this delegate
                                message.
 @param     response            The response to be handled.
 */
- (void)application:(CGIApplication *)application
    didSendResponse:(CGIHTTPResponse *)response;

/**
 Called when the application is going to be terminated.
 
 @param     application         The application object that sent this delegate
                                message.
 */
- (void)applicationWillTerminate:(CGIApplication *)application;

/**
 @name      Context Controlling
 */

/**
 @brief     Called by the applicaiton to obtain new delegate for the context.
 
 The context delegate will catch all delegate methods instead of the app
 delegate.
 
 @param     application         The application object that sent this delegate
                                message.
 @return    The new context delegate. Return nil will make application delegate
            the handler of connection messages.
 */
- (id<CGIHTTPContextDelegate>)application:(CGIApplication *)application
                       delegateForContext:(CGIHTTPContext *)context;

@end

/**
 Object that represents and manages the execution of a (Fast)CGI application.
 */
@interface CGIApplication : NSObject

/**
 @name      Application Delegate
 */

/**
 Application delegate.
 */
@property id<CGIApplicationDelegate> delegate;

/**
 @name      Shared Instance
 */

/**
 Obtains the shared instance of CGIApplication.
 
 @return    The shared instance of CGIApplication.
 */
+ (instancetype)sharedApplication;

/**
 @name      Running the application
 */

/**
 Start the application.
 
 @note      Generally, you do not invoke this method directly. You call function
            CGIApplicationMain instead.
 
 @return    This method does not return despite the int return type.
 */
- (int)run MSNoReturn;

/**
 Obtains the version string of CGIKit.
 
 @return    The library version string.
 */
- (NSString *)versionString;

#pragma mark - Lifecycle and delegate methods

/**
 @name      Application Lifecycle
 */

/**
 Called when the application did finished launching. You should finish app-
 specific initialization in this method.
 */
- (void)applicationDidFinishLaunching;

/**
 Called when an application received a request. You can reject a request with
 this method, and a rejected request will be responded with HTTP 501 Not
 Implemented response. Also, you should set up environemnt of handling the
 request in this method.
 
 @note      This method is expected to be thread-safe. It could be overridden by
            the delegate of the context.
 
 @param     request             The request to be handled.
 @return    Whether the input should be handled. You can reject the request by
            returning NO.
 */
- (BOOL)applicationShouldHandleRequest:(CGIHTTPRequest *)request;

/**
 Called to handle the HTTP request and generate the response.
 
 @note      This method is expected to be thread-safe. It could be overridden by
            the delegate of the context.

 @param     context             The HTTP context to be handled.
 */
- (void)applicationHandleHTTPContext:(CGIHTTPContext *)context;

/**
 Called when an application is going to send a response. You can redact a
 response by returning NO from this method, and a redacted response will be
 replaced with a HTTP 403 Forbidden response.
 
 @note      This method is expected to be thread-safe. It could be overridden by
 the delegate of the context.

 @param     response            The response to be handled.
 @return    Whether the response should be sent. Return NO to redact the
            response.
 */
- (BOOL)applicationShouldSendResponse:(CGIHTTPResponse *)response;

/**
 Called when an application finished sending a response.
 
 @note      This method is expected to be thread-safe. It could be overridden by
            the delegate of the context.
 
 @param     response            The response to be handled.
 */
- (void)applicationDidSendResponse:(CGIHTTPResponse *)response;

/**
 Called when the application is going to be terminated.
 */
- (void)applicationWillTerminate;

/**
 @name      Context Controlling
 */

/**
 @brief     Called by the applicaiton to obtain new delegate for the context.
 
 The context delegate will catch connection events before application delegate
 does.
 
 @return    The new context delegate. Return nil will make application delegate
            the handler of connection messages.
 */
- (id<CGIHTTPContextDelegate>)applicationDelegateForContext:(CGIHTTPContext *)context;

@end

#endif

__END_DECLS

#endif
