//
//  CGIHTTPContext.m
//  CGIKit
//
//  Created by Maxthon Chan on 8/1/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "CGIHTTPContext.h"
#import "CGIHTTPRequest.h"
#import "CGIHTTPResponse.h"
#import "CGIApplication.h"
#import "fcgi/fcgi_stdio.h"

static BOOL _CGI_Executed;

@implementation CGIHTTPContext
{
    FCGX_Request _fcgi_request;
    dispatch_group_t _group;
    dispatch_queue_t _queue;
    
    CGIHTTPRequest *_request;
    CGIHTTPResponse *_response;
    id<CGIHTTPContextDelegate> _delegate;
}

- (id)initWithDisptachGroup:(dispatch_group_t)group delegate:(id<CGIHTTPContextDelegate>)delegate
{
    self = [super init];
    if (self) {
        if (!FCGX_IsCGI())
        {
            if (FCGX_InitRequest(&_fcgi_request, 0, 0))
                return self = nil;
            
            if (FCGX_Accept_r(&_fcgi_request))
                return self = nil;
            
        }
        else
        {
            @synchronized (CGIApp)
            {
                if (_CGI_Executed)
                {
                    return self = nil;
                }
                _CGI_Executed = YES;
            }
        }
        _group = group;
        _queue = dispatch_queue_create("", 0);
        _delegate = delegate;
    }
    return self;
}

- (void)run
{
    dispatch_group_async(_group, _queue, ^{
        _request = [[CGIHTTPRequest alloc] init];
        
        // Parse the request
        
        if (!FCGX_IsCGI())
        {
            NSMutableDictionary *environment = [NSMutableDictionary dictionary];
            for (char **cp = _fcgi_request.envp; *cp; cp++)
            {
                char *env = *cp;
                char *split = strchr(env, '=');
                NSString *key = [[NSString alloc] initWithData:[NSData dataWithBytes:env
                                                                              length:split - env]
                                                      encoding:NSUTF8StringEncoding];
                NSString *value = [[NSString alloc] initWithCString:split + 1
                                                           encoding:NSUTF8StringEncoding];
                environment[key] = value;
            }
            _request.environemnt = [NSDictionary dictionaryWithDictionary:environment];
            
            NSUInteger length = _request.contentLength;
            if (length > 0)
            {
                void *data = malloc(length);
                FCGX_GetStr(data, (int)length, _fcgi_request.in);
                _request.data = [NSData dataWithBytesNoCopy:data
                                                     length:length
                                               freeWhenDone:YES];
            }
            else
            {
                _request.data = [NSData data];
            }
        }
        else
        {
            _request.environemnt = [[NSProcessInfo processInfo] environment];
            
            NSUInteger length = _request.contentLength;
            if (length > 0)
            {
                void *data = malloc(length);
                fread(data, length, 1, stdin);
                _request.data = [NSData dataWithBytesNoCopy:data
                                                     length:length
                                               freeWhenDone:YES];
            }
            else
            {
                _request.data = [NSData data];
            }
        }
        
        _response = [[CGIHTTPResponse alloc] init];
        
        @try
        {
            if ([self contextShouldHandleRequest:_request])
            {
                [self handleHTTPContext];
                if (![self contextShouldSendResponse:_response])
                {
                    [_response setResponseWithRedactedResponse];
                }
            }
            else
            {
                [_response setResponseWithRejectedRequest];
            }
        }
        @catch (NSException *exception)
        {
            NSLog(@"Exception: %@", exception);
            [_response setResponseWithException:exception];
        }
        
        @try
        {
            [self contextDidSendResponse:_response];
        }
        @catch (NSException *exception)
        {
            NSLog(@"Exception: %@", exception);
        }
        
        
        if (!FCGX_IsCGI())
            FCGX_Finish_r(&_fcgi_request);
        
        objc_release(self);
    });
}

- (BOOL)contextShouldHandleRequest:(CGIHTTPRequest *)request
{
    if ([self.delegate respondsToSelector:@selector(context:shouldHandleRequest:)])
        return [self.delegate context:self shouldHandleRequest:request];
    else
        return [[CGIApplication sharedApplication] applicationShouldHandleRequest:request];
}

- (void)handleHTTPContext
{
    if ([self.delegate respondsToSelector:@selector(handleHTTPContext:)])
        [self.delegate handleHTTPContext:self];
    else
        [[CGIApplication sharedApplication] applicationHandleHTTPContext:self];
}

- (BOOL)contextShouldSendResponse:(CGIHTTPResponse *)response
{
    if ([self.delegate respondsToSelector:@selector(context:shouldSendResponse:)])
        return [self.delegate context:self shouldSendResponse:response];
    else
        return [[CGIApplication sharedApplication] applicationShouldSendResponse:response];
}

- (void)contextDidSendResponse:(CGIHTTPResponse *)response
{
    if ([self.delegate respondsToSelector:@selector(context:didSendResponse:)])
        [self.delegate context:self didSendResponse:response];
    else
        return [[CGIApplication sharedApplication] applicationDidSendResponse:response];
}

@end