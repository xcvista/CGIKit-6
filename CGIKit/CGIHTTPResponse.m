//
//  CGIHTTPResponse.m
//  CGIKit
//
//  Created by Maxthon Chan on 8/2/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "CGIHTTPResponse.h"
#import "CGIApplication.h"

@implementation CGIHTTPResponse

- (id)init
{
    if (self = [super init])
    {
        self.headers = [NSMutableDictionary dictionary];
        self.data = [NSMutableData data];
    }
    return self;
}

- (void)prepareForSend
{
    if ([self.headers[CGIHTTPResponseLocationKey] length])
    {
        [self.data setLength:0];
    }
    else
    {
        self.contentLength = [self.data length];
    }
    
    if ([self.data length])
    {
        [self.headers removeObjectForKey:CGIHTTPResponseContentLengthKey];
    }
    
    for (NSString *key in [self.headers allKeys])
    {
        id object = self.headers[key];
        self.headers[key] = [object description];
    }
    
    self.headers[CGIHTTPResponsePoweredByKey] = [[CGIApplication sharedApplication] versionString];
}

#pragma mark - Property rewritings

- (CGIHTTPResponseCode)statusCode
{
    return [self.headers[CGIHTTPResponseStatusKey] unsignedIntegerValue];
}

- (void)setStatusCode:(CGIHTTPResponseCode)statusCode
{
    self.headers[CGIHTTPResponseStatusKey] = @(statusCode);
}

- (NSString *)contentType
{
    return self.headers[CGIHTTPResponseContentTypeKey];
}

- (void)setContentType:(NSString *)contentType
{
    self.headers[CGIHTTPResponseContentTypeKey] = contentType;
}

- (NSUInteger)contentLength
{
    NSNumber *length = self.headers[CGIHTTPResponseContentLengthKey];
    if (length)
        return [length unsignedIntegerValue];
    else
    {
        return self.contentLength = [self.data length];
    }
}

- (void)setContentLength:(NSUInteger)contentLength
{
    self.headers[CGIHTTPResponseContentLengthKey] = @(contentLength);
}

- (NSString *)setCookie
{
    return self.headers[CGIHTTPResponseSetCookieKey];
}

- (void)setSetCookie:(NSString *)setCookie
{
    self.headers[CGIHTTPResponseSetCookieKey] = setCookie;
}

#pragma mark - Response convenience methods

- (void)setResponseWithTemplatePage:(NSString *)template substitutions:(NSDictionary *)substitutions
{
    NSMutableString *string = [NSMutableString stringWithString:template];
    
    for (id key in substitutions)
    {
        NSString *replace = MSSTR(@"{%@}", key);
        NSString *with = MSSTR(@"%@", substitutions[key]);
        
        [string replaceOccurrencesOfString:replace
                                withString:with
                                   options:0
                                     range:NSMakeRange(0, [string length])];
    }
    
    self.contentType = @"text/html; charset=utf-8";
    [self.data setData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)setResponseWithError:(NSError *)error
{
    [self setResponseWithError:error
                    statusCode:CGIHTTPResponseInternalServerError];
}

- (void)setResponseWithError:(NSError *)error statusCode:(CGIHTTPResponseCode)statusCode
{
    NSString *template = [NSString stringWithContentsOfURL:[[NSBundle bundleForClass:[self class]] URLForResource:@"error"
                                                                                                    withExtension:@"html"]
                                              usedEncoding:NULL
                                                     error:NULL];
    
    self.statusCode = statusCode;
    
    [self setResponseWithTemplatePage:template
                        substitutions:@{
                                        @"errorTitle": [error localizedDescription],
                                        @"errorSubtitle": MSSTR(NSLocalizedString(@"%@ error %ld", nil),
                                                                [error domain],
                                                                [error code]),
                                        @"errorDetails": [error localizedFailureReason],
                                        @"serverSignature": [[CGIApplication sharedApplication] versionString],
                                        @"statusCode": @(self.statusCode),
                                        }];
}

- (void)setResponseWithException:(NSException *)exception
{
    NSString *template = [NSString stringWithContentsOfURL:[[NSBundle bundleForClass:[self class]] URLForResource:@"error"
                                                                                                    withExtension:@"html"]
                                              usedEncoding:NULL
                                                     error:NULL];
    self.statusCode = CGIHTTPResponseInternalServerError;
    [self setResponseWithTemplatePage:template
                        substitutions:@{
                                        @"errorTitle": [exception name],
                                        @"errorSubtitle": MSSTR(NSLocalizedString(@"%@: %@", nil),
                                                                NSStringFromClass([exception class]),
                                                                [exception reason]),
                                        @"errorDetails": MSSTR(@""),
                                        @"serverSignature": [[CGIApplication sharedApplication] versionString],
                                        @"statusCode": @(self.statusCode),
                                        }];
}

- (void)setResponseWithRedirection:(NSString *)target
{
    [self setResponseWithRedirection:target
                          statusCode:CGIHTTPResponseFound];
}

- (void)setResponseWithRedirection:(NSString *)target statusCode:(CGIHTTPResponseCode)statusCode
{
    [self.data setLength:0];
    self.headers[CGIHTTPResponseLocationKey] = target;
    self.statusCode = statusCode;
}

- (void)setResponseWithRejectedRequest
{
    [self setResponseWithError:[NSError errorWithDomain:CGIHTTPResponseErrorDomain
                                                   code:CGIHTTPResponseRejectedError
                                               userInfo:@{
                                                          NSLocalizedDescriptionKey: NSLocalizedString(@"The service is not implemented.", nil),
                                                          NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The request is rejected bt the application.", nil),
                                                          }]
                    statusCode:CGIHTTPResponseNotImplemented];
}

- (void)setResponseWithRedactedResponse
{
    [self setResponseWithError:[NSError errorWithDomain:CGIHTTPResponseErrorDomain
                                                   code:CGIHTTPResponseRedactedError
                                               userInfo:@{
                                                          NSLocalizedDescriptionKey: NSLocalizedString(@"The request is forbidden.", nil),
                                                          NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The request is redacted last minute by the application.", nil)
                                                          }]
                    statusCode:CGIHTTPResponseForbidden];
}

@end

#import <MSBooster/MSBooster_Private.h>
#include "CGIHTTPResponseStrings.h"
