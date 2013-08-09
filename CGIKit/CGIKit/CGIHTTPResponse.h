//
//  CGIHTTPResponse.h
//  CGIKit
//
//  Created by Maxthon Chan on 8/2/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MSBooster/MSBooster.h>

/**
 @enum      CGIHTTPResponseCode
 
 HTTP Response Codes.
 
 @see       RFC 2616
 */
typedef NS_ENUM(NSUInteger, CGIHTTPResponseCode)
{
#pragma mark Informational
    /// Continue the rest of the request.
    CGIHTTPResponseContinue = 100,
    
    /// Switch to another protocol and continue.
    CGIHTTPResponseSwitchingProtocols,
    
#pragma mark Succeed
    /// The request is processed successfully.
    CGIHTTPResponseOK = 200,
    
    /// The requested file have been created.
    CGIHTTPResponseCreated,
    
    /// The request have been accepted.
    CGIHTTPResponseAccepted,
    CGIHTTPResponseNonAuthoritativeInformation,
    CGIHTTPResponseNoContent,
    CGIHTTPResponseResetContent,
    CGIHTTPResponsePartialContent,
    
    CGIHTTPResponseMultipleChoices = 300,
    CGIHTTPResponseMovedPermanently,
    CGIHTTPResponseFound,
    CGIHTTPResponseSeeOther,
    CGIHTTPResponseNotModified,
    CGIHTTPResponseUseProxy,
    CGIHTTPResponseTemporaryRedirect = 307,
    
    CGIHTTPResponseBadRequest = 400,
    CGIHTTPResponseUnauthorized,
    CGIHTTPResponsePaymentRequired,
    CGIHTTPResponseForbidden,
    CGIHTTPResponseNotFound,
    CGIHTTPResponseMethodNotAllowed,
    CGIHTTPResponseNotAcceptable,
    CGIHTTPResponseProxyAuthenticationRequired,
    CGIHTTPResponseConflict,
    CGIHTTPResponseGone,
    CGIHTTPResponseLengthRequired,
    CGIHTTPResponsePreconditionFailed,
    CGIHTTPResponseRequestEntityTooLarge,
    CGIHTTPResponseRequestURITooLong,
    CGIHTTPResponseUnsupportedMediaType,
    CGIHTTPResponseRequestedRangeNotSatisfiable,
    CGIHTTPResponseExpectationFailed,
    
    CGIHTTPResponseInternalServerError = 500,
    CGIHTTPResponseNotImplemented,
    CGIHTTPResponseBadGateway,
    CGIHTTPResponseServiceUnavailable,
    CGIHTTPResponseGatewayTimeout,
    CGIHTTPResponseHTTPVersionNotSupported,
};

@interface CGIHTTPResponse : NSObject

#pragma mark - Response body

@property NSMutableDictionary *headers;
@property NSMutableData *data;

#pragma mark Accessors

@property (nonatomic) CGIHTTPResponseCode statusCode;

@property (nonatomic) NSString *contentType;
@property (nonatomic) NSString *setCookie;

#pragma mark - Easy error reporting methods

- (void)setResponseWithError:(NSError *)error;
- (void)setResponseWithError:(NSError *)error statusCode:(CGIHTTPResponseCode)statusCode;
- (void)setResponseWithException:(NSException *)exception;
- (void)setResponseWithRedirection:(NSString *)target;
- (void)setResponseWithRedirection:(NSString *)target statusCode:(CGIHTTPResponseCode)statusCode;

@end

#include <CGIKit/CGIHTTPResponseStrings.h>
