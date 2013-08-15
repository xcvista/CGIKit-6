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

@synthesize queryString = _queryString;
@synthesize form = _form;

- (NSString *)httpMethod
{
    return self.environemnt[CGIHTTPRequestMethodKey];
}

- (NSString *)requestURI
{
    return self.environemnt[CGIHTTPRequestURIKey];
}

- (NSString *)protocol
{
    return self.environemnt[CGIHTTPRequestServerProtocolKey];
}

- (NSString *)userAgent
{
    return self.environemnt[CGIHTTPRequestUserAgentKey];
}

- (NSInteger)contentLength
{
    return [self.environemnt[CGIHTTPRequestContentLengthKey] integerValue];
}

#pragma mark - Forms and query strings.

- (NSDictionary *)_CGI_DictionaryFromQuesryStyleString:(NSString *)string
{
    NSArray *parts = [string componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:[parts count]];
    
    for (NSString *part in parts)
    {
        NSArray *components = [part componentsSeparatedByString:@"="];
        NSString *value = [[components lastObject] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *key = ([components count] > 1) ? [components[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] : @"";
        
        if (!key)
            key = @"";
        if (value)
            dict[key] = value;
    }
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

- (NSDictionary *)queryString
{
    if (!_queryString)
    {
        NSString *queryString = self.environemnt[CGIHTTPRequestQueryStringKey];
        _queryString = [self _CGI_DictionaryFromQuesryStyleString:queryString];
    }
    return _queryString;
}

- (NSDictionary *)form
{
    if (!_form)
    {
        NSString *form = [[NSString alloc] initWithData:self.data
                                               encoding:NSASCIIStringEncoding];
        _form = [self _CGI_DictionaryFromQuesryStyleString:form];
    }
    return _form;
}

@end

#import <MSBooster/MSBooster_Private.h>
#include "CGIHTTPRequestStrings.h"
