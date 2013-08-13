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
        
        exit([app run]);
    }
}

@implementation CGIApplication

+ (instancetype)sharedApplication
{
    if (!CGIApp)
    {
        CGIApp = [[self alloc] init];
    }
    
    return CGIApp;
}

- (int)run
{
    if (FCGX_IsCGI() && FCGX_Init())
        exit(1);
    
    [self applicationDidFinishLaunching];
    
    CGIHTTPContext *context = nil;
    
    dispatch_group_t group = dispatch_group_create();
    
    while ((context = [[CGIHTTPContext alloc] initWithDisptachGroup:group delegate:[self createDelegateForContext]]))
    {
        [(CGIHTTPContext *)objc_retain(context) run];
    }
    
    [self applicationWillTerminate];
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
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
    
    return MSSTR(NSLocalizedString(@"<address>CGIKit/6.0 (version 6A16, %@) &copy; 2011-2013 Maxthon T. Chan et al.</address>", nil));
}

- (void)applicationDidFinishLaunching
{
    if ([self.delegate respondsToSelector:@selector(applicationDidFinishLaunching:)])
        [self.delegate applicationDidFinishLaunching:self];
}

- (id<CGIHTTPContextDelegate>)createDelegateForContext
{
    if ([self.delegate respondsToSelector:@selector(createDelegateForContext:)])
        return [self.delegate createDelegateForContext:self];
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