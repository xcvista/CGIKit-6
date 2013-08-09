//
//  CGIHTTPRequest.m
//  CGIKit
//
//  Created by Maxthon Chan on 8/1/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "CGIHTTPRequest.h"
#import "fcgi/fcgi_stdio.h"
#import <MSBooster/MSBooster.h>

extern char **environ;

@implementation CGIHTTPRequest

- (id)init
{
    if (self = [super init])
    {
        NSMutableDictionary *environment = [NSMutableDictionary dictionary];
        for (char **cp = environ; *cp; cp++)
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
        _environemnt = [NSDictionary dictionaryWithDictionary:environment];
    }
    return self;
}

- (NSString *)httpMethod
{
    return self.environemnt[CGIHTTPRequestMethodKey];
}

- (NSString *)requestURI
{
    return self.environemnt[CGIHTTPRequestURIKey];
}

@end

#import <MSBooster/MSBooster_Private.h>

#include "CGIHTTPRequestStrings.h"
