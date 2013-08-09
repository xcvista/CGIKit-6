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
 
 @param     argc                Number of arguments passed to \c main()
 @param     argv                Argument vector passed to \c main()
 @param     applicationClass    Name of class of the application. Default to \c
                                CGIApplication.
 @param     delegateClass       Name of class of the application delegate.
 */
extern int MSNoReturn CGIApplicationMain(int argc,
                                         const char **argv,
                                         NSString *applicationClass,
                                         NSString *delegateClass);

/**
 Shared instance of current \c CGIApplication.
 
 @see   +[CGIApplication sharedApplication]
 */
extern id CGIApp;

MSConstantString(CGIApplicationName, CGIApplication);

#if __OBJC__

/**
 Application delegate for the Web application.
 
 @see   NSApplicationDelegate
 */
@protocol CGIApplicationDelegate <NSObject>

@optional
- (void)applicationDidFinishLaunching:(CGIApplication *)application;
- (BOOL)application:(CGIApplication *)application shouldHandleRequest:(CGIHTTPRequest *)request;
- (void)application:(CGIApplication *)application handleHTTPContext:(CGIHTTPContext *)request;
- (BOOL)application:(CGIApplication *)application shouldSendResponse:(CGIHTTPResponse *)response;
- (void)application:(CGIApplication *)application didSendResponse:(CGIHTTPResponse *)response;
- (void)applicationWillTerminate:(CGIApplication *)application;

@end

@interface CGIApplication : NSObject

@property id<CGIApplicationDelegate> delegate;

+ (instancetype)sharedApplication;

- (int)run MSNoReturn;

// Lifecycle

- (void)applicationDidFinishLaunching;
- (BOOL)applicationShouldHandleRequest:(CGIHTTPRequest *)request;
- (void)applicationHandleHTTPContext:(CGIHTTPContext *)request;
- (BOOL)applicationShouldSendResponse:(CGIHTTPResponse *)response;
- (void)applicationDidSendResponse:(CGIHTTPResponse *)response;
- (void)applicationWillTerminate;

@end

#endif

__END_DECLS

#endif
