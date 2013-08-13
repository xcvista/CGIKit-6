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
 HTTP Response Codes as defined in RFC 2616.
 */
typedef NS_ENUM(NSUInteger, CGIHTTPResponseCode)
{

    /// Continue the rest of the request.
    CGIHTTPResponseContinue = 100,
    /// Switch to another protocol and continue.
    CGIHTTPResponseSwitchingProtocols,

    /// The request is processed successfully.
    CGIHTTPResponseOK = 200,
    /// The requested file have been created.
    CGIHTTPResponseCreated,
    /// The request have been accepted.
    CGIHTTPResponseAccepted,
    /// The response is non-authoritative.
    CGIHTTPResponseNonAuthoritativeInformation,
    /// The response is empty.
    CGIHTTPResponseNoContent,
    /// The request is processed. Please reset the form.
    CGIHTTPResponseResetContent,
    /// The response is part of the complete response.
    CGIHTTPResponsePartialContent,
    
    /// There are multiple choices possible for the response.
    CGIHTTPResponseMultipleChoices = 300,
    /// The requested object is permanently moved to another location.
    CGIHTTPResponseMovedPermanently,
    /// The requested object is found at another location.
    CGIHTTPResponseFound,
    /// The
    CGIHTTPResponseSeeOther,
    /// The requested content is not modified since last request.
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
@property (nonatomic) NSUInteger contentLength;
@property (nonatomic) NSString *contentType;
@property (nonatomic) NSString *setCookie;

#pragma mark - Easy error reporting methods

- (void)setResponseWithTemplatePage:(NSString *)template substitutions:(NSDictionary *)substitutions;
- (void)setResponseWithError:(NSError *)error;
- (void)setResponseWithError:(NSError *)error statusCode:(CGIHTTPResponseCode)statusCode;
- (void)setResponseWithException:(NSException *)exception;
- (void)setResponseWithRedirection:(NSString *)target;
- (void)setResponseWithRedirection:(NSString *)target statusCode:(CGIHTTPResponseCode)statusCode;
- (void)setResponseWithRejectedRequest;
- (void)setResponseWithRedactedResponse;

@end

#include <CGIKit/CGIHTTPResponseStrings.h>
