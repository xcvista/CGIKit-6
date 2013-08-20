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
#import "fcgi/fcgiapp.h"

static BOOL _CGI_Executed;
static BOOL _CGI_Bad;

@interface CGIHTTPResponse (CGIInternal)

- (void)prepareForSend;

@end

@implementation CGIHTTPContext
{
    FCGX_Request _fcgi_request;
    
    CGIHTTPRequest *_request;
    CGIHTTPResponse *_response;
    id<CGIHTTPContextDelegate> _delegate;
}

- (id)init
{
    if (_CGI_Bad)
        return self = nil;
    
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
        _delegate = nil;
    }
    return self;
}

- (void)main
{
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
        _CGI_Bad = YES;
    }
    
    @try
    {
        [_response prepareForSend];
        
        // Write headers
        for (NSString *key in _response.headers)
        {
            NSString *value = _response.headers[key];
            
            NSString *line = MSSTR(@"%@: %@",
                                   [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                                   [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]);
            if (FCGX_IsCGI())
            {
                fprintf(stdout, "%s\n", [line cStringUsingEncoding:NSASCIIStringEncoding]);
            }
            else
            {
                FCGX_FPrintF(_fcgi_request.out, "%s\n", [line cStringUsingEncoding:NSASCIIStringEncoding]);
            }
        }
        
        if (FCGX_IsCGI())
        {
            fputc('\n', stdout);
            fwrite([_response.data bytes], [_response.data length], 1, stdout);
        }
        else
        {
            FCGX_PutChar('\n', _fcgi_request.out);
            FCGX_PutStr([_response.data bytes], (int)[_response.data length], _fcgi_request.out);
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception: %@", exception);
        _CGI_Bad = YES;
    }
    
    @try
    {
        [self contextDidSendResponse:_response];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception: %@", exception);
        _CGI_Bad = YES;
    }
    
    
    if (!FCGX_IsCGI())
        FCGX_Finish_r(&_fcgi_request);
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
