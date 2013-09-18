//
//  CGIRemoteConnection.m
//  CGIJSONKit
//
//  Created by Maxthon Chan on 13-5-22.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "CGIRemoteConnection.h"
#import <MSBooster/MSBooster.h>
#import <sys/utsname.h>

CGIRemoteConnection *_CGI_defaultRemoteConnection;

NSString *const CGIHTTPErrorDomain __attribute__((weak)) = @"info.maxchan.error.http";
NSString *const CGIRemoteConnectionServerRootKey = @"CGIRemoteConnectionServerRoot";

@implementation CGIRemoteConnection

+ (instancetype)defaultRemoteConnection
{
    if (!_CGI_defaultRemoteConnection)
        _CGI_defaultRemoteConnection = [[self alloc] init];
    return _CGI_defaultRemoteConnection;
}

- (void)makeDefaultServerRoot
{
    _CGI_defaultRemoteConnection = self;
}

- (id)init
{
    return [self initWithServerRoot:nil];
}

- (id)initWithServerRoot:(NSString *)serverRoot
{
    if (self = [super init])
    {
        if (!serverRoot)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *root = [defaults objectForKey:CGIRemoteConnectionServerRootKey];
            serverRoot = [NSURL URLWithString:root];
        }
        self.serverRoot = serverRoot;
    }
    return self;
}

- (NSMutableURLRequest *)URLRequestForMethod:(NSString *)method
{
    if (!self.serverRoot)
    {
        [NSException raise:@"CGINotReadyException" format:@"No server root is provided."];
    }
    
    NSURL *methodURL = [NSURL URLWithString:MSSTR(self.serverRoot, method)];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:methodURL];
    [request setValue:[self userAgent]
   forHTTPHeaderField:@"User-Agent"];
    
    return request;
}

- (NSData *)dataWithData:(NSData *)data
              fromMethod:(NSString *)method
                   error:(NSError *__autoreleasing *)error
{
    
    NSMutableURLRequest *request = [self URLRequestForMethod:method];
    
    if ([data length])
    {
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:data];
        
        [request setValue:@"application/json;charset=utf-8"
       forHTTPHeaderField:@"Content-Type"];
    }
    
    NSError *err = nil;
    NSHTTPURLResponse *response = nil;
    
    NSData *responseData = nil;
    
    if ([self connectionShouldSendURLRequest:request])
    {
        responseData = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response
                                                         error:&err];
    }
    else
    {
        err = [NSError errorWithDomain:CGIHTTPErrorDomain code:-95 userInfo:nil];
    }
    
    if (![responseData length])
    {
        MSAssignPointer(error, err);
        return nil;
    }
    
    if ([response statusCode] >= 400)
    {
        NSLog(@"HTTP status %3d from method %@", (int32_t)[response statusCode], method);
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey:
                                       [NSHTTPURLResponse localizedStringForStatusCode:[response statusCode]],
                                   };
        err = [NSError errorWithDomain:CGIHTTPErrorDomain
                                  code:[response statusCode]
                              userInfo:userInfo];
        MSAssignPointer(error, err);
        return nil;
    }
    
    return responseData;
}

- (NSString *)userAgent
{
    NSString *utname = @"Unknown OS";
    struct utsname utsname;
    if (!uname(&utsname))
    {
        utname = MSSTR(@"%s/%s", utsname.sysname, utsname.release);
    }
    
    return MSSTR(@"CGIJSONRemoteObject/6.0; CGIKit/6.0; %@",
                  utname
                  );
}

- (BOOL)connectionShouldSendURLRequest:(NSMutableURLRequest *)request
{
    if ([self.delegate respondsToSelector:@selector(connection:shouldSendURLRequset:)])
        return [self.delegate connection:self shouldSendURLRequset:request];
    else
        return YES;
}

@end
