//
//  CGIApplication.m
//  CGIKit
//
//  Created by Maxthon Chan on 7/31/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "CGIApplication.h"
#import "fcgi/fcgi_stdio.h"

#import "CGIHTTPContext.h"

#import <sys/utsname.h>

id CGIApp;

int MSNoReturn CGIApplicationMain(int argc,
                                  const char **argv,
                                  NSString *applicationClass,
                                  NSString *delegateClass)
{
    @autoreleasepool
    {
        Class appClass = NSClassFromString(applicationClass);
        Class delClass = NSClassFromString(delegateClass);
        
        if (!appClass)
            appClass = [CGIApplication class];
        
        CGIApplication *app = [appClass sharedApplication];
        app.delegate = [[delClass alloc] init];
        
        int rv = [app run];
        exit(rv);
    }
}

@implementation CGIApplication
{
    NSOperationQueue *_queue;
}

+ (instancetype)sharedApplication
{
    if (!CGIApp)
    {
        CGIApp = [[self alloc] init];
    }
    
    return CGIApp;
}

- (id)init
{
    if (self = [super init])
    {
        _queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (int)run
{
    if (FCGX_IsCGI() && FCGX_Init())
        exit(1);
    
    [self applicationDidFinishLaunching];
    
    CGIHTTPContext *context = nil;
    
    while ((context = [[CGIHTTPContext alloc] init]))
    {
        context.delegate = [self applicationDelegateForContext:context];
        [_queue addOperation:context];
    }
    
    [_queue waitUntilAllOperationsAreFinished];
    
    [self applicationWillTerminate];
    
    exit(0);
}

- (NSString *)versionString
{
    NSString *system = @"Unknown-OS";
    
    struct utsname utsname;
    if (!uname(&utsname))
    {
        system = MSSTR(@"%s/%s", utsname.sysname, utsname.release);
    }
    
    return MSSTR(NSLocalizedString(@"CGIKit/6.0 (version 6A16, %@) &copy; 2011-2013 Maxthon T. Chan et al.", nil), system);
}

- (void)applicationDidFinishLaunching
{
    if ([self.delegate respondsToSelector:@selector(applicationDidFinishLaunching:)])
        [self.delegate applicationDidFinishLaunching:self];
}

- (id<CGIHTTPContextDelegate>)applicationDelegateForContext:(CGIHTTPContext *)context
{
    if ([self.delegate respondsToSelector:@selector(application:delegateForContext:)])
        return [self.delegate application:self delegateForContext:context];
    else
        return nil;
}

- (BOOL)applicationShouldHandleRequest:(CGIHTTPRequest *)request
{
    if ([self.delegate respondsToSelector:@selector(application:shouldHandleRequest:)])
        return [self.delegate application:self shouldHandleRequest:request];
    else
        return YES;
}

- (void)applicationHandleHTTPContext:(CGIHTTPContext *)request
{
    if ([self.delegate respondsToSelector:@selector(application:handleHTTPContext:)])
        [self.delegate application:self handleHTTPContext:request];
}

- (BOOL)applicationShouldSendResponse:(CGIHTTPResponse *)response
{
    if ([self.delegate respondsToSelector:@selector(application:shouldSendResponse:)])
        return [self.delegate application:self shouldSendResponse:response];
    else
        return YES;
}

- (void)applicationDidSendResponse:(CGIHTTPResponse *)response
{
    if ([self.delegate respondsToSelector:@selector(application:didSendResponse:)])
        [self.delegate application:self didSendResponse:response];
}

- (void)applicationWillTerminate
{
    if ([self.delegate respondsToSelector:@selector(applicationWillTerminate:)])
        [self.delegate applicationWillTerminate:self];
}

@end

#import <MSBooster/MSBooster_Private.h>

MSConstantString(CGIApplicationName, CGIApplication);
