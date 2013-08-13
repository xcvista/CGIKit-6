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
    [self setResponseWithTemplatePage:template
                        substitutions:@{
                                        @"errorTitle": [error localizedDescription],
                                        @"errorSubtitle": MSSTR(NSLocalizedString(@"%@ error %ld", nil),
                                                                [error domain],
                                                                [error code]),
                                        @"errorDetails": [error localizedFailureReason],
                                        @"serverSignature": [[CGIApplication sharedApplication] versionString]
                                        }];
    self.statusCode = statusCode;
    
}

- (void)setResponseWithException:(NSException *)exception
{
    NSString *template = [NSString stringWithContentsOfURL:[[NSBundle bundleForClass:[self class]] URLForResource:@"error"
                                                                                                    withExtension:@"html"]
                                              usedEncoding:NULL
                                                     error:NULL];
    [self setResponseWithTemplatePage:template
                        substitutions:@{
                                        @"errorTitle": [exception name],
                                        @"errorSubtitle": MSSTR(NSLocalizedString(@"%@: %@", nil),
                                                                NSStringFromClass([exception class]),
                                                                [exception reason]),
                                        @"errorDetails": MSSTR(@""),
                                        @"serverSignature": [[CGIApplication sharedApplication] versionString]
                                        }];
    self.statusCode = CGIHTTPResponseInternalServerError;
}

- (void)setResponseWithRedirection:(NSString *)target
{
    [self setResponseWithRedirection:target
                          statusCode:CGIHTTPResponseFound];
}

@end

#import <MSBooster/MSBooster_Private.h>
#include "CGIHTTPResponseStrings.h"
