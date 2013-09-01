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
    /// The server requires the client to load another address.
    CGIHTTPResponseSeeOther,
    /// The requested content is not modified since last request.
    CGIHTTPResponseNotModified,
    /// A proxy server is required to access the given content.
    CGIHTTPResponseUseProxy,
    /// The content is temoprarily moved.
    CGIHTTPResponseTemporaryRedirect = 307,
    
    /// The request is malformed.
    CGIHTTPResponseBadRequest = 400,
    /// The request cannot be fulfilled due to lack of authentication.
    CGIHTTPResponseUnauthorized,
    /// The requested content requires payment.
    CGIHTTPResponsePaymentRequired,
    /// The client is not allowed to access the resource requested.
    CGIHTTPResponseForbidden,
    /// The resource is not found on the server.
    CGIHTTPResponseNotFound,
    /// The HTTP method is not allowed on the server.
    CGIHTTPResponseMethodNotAllowed,
    /// The request is not acceptable to the server.
    CGIHTTPResponseNotAcceptable,
    /// The request must carry proxy authentication information.
    CGIHTTPResponseProxyAuthenticationRequired,
    /// Requests conflicted with each other.
    CGIHTTPResponseConflict,
    /// The request file is gome permanantly and cannot be found back.
    CGIHTTPResponseGone,
    /// The request does not have a length header which is required.
    CGIHTTPResponseLengthRequired,
    /// Preconditions indicated in the header failed to match.
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

enum
{
    CGIHTTPResponseRedactedError,
    CGIHTTPResponseRejectedError,
};

@interface CGIHTTPResponse : NSObject

/**
 @name      Response body
 */

/// HTTP header fields.
@property NSMutableDictionary *headers;
/// HTTP response data.
@property NSMutableData *data;

/**
 @name      Accessors
 */

/// HTTP response code.
@property (nonatomic) CGIHTTPResponseCode statusCode;
/// Length of the HTTP response object.
@property (nonatomic) NSUInteger contentLength;
/// MIME type of the response data.
@property (nonatomic) NSString *contentType;
/// Cookies to be set at the server.
@property (nonatomic) NSString *setCookie;

/**
 @name      Convenience methods
 */

- (void)setResponseWithTemplatePage:(NSString *)template
                      substitutions:(NSDictionary *)substitutions;
- (void)setResponseWithError:(NSError *)error;
- (void)setResponseWithError:(NSError *)error
                  statusCode:(CGIHTTPResponseCode)statusCode;
- (void)setResponseWithException:(NSException *)exception;
- (void)setResponseWithRedirection:(NSString *)target;
- (void)setResponseWithRedirection:(NSString *)target
                        statusCode:(CGIHTTPResponseCode)statusCode;
- (void)setResponseWithRejectedRequest;
- (void)setResponseWithRedactedResponse;

@end

#include <CGIKit/CGIHTTPResponseStrings.h>
