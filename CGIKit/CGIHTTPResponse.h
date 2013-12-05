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
    /// The request entity is too large for the application to handle.
    CGIHTTPResponseRequestEntityTooLarge,
    /// The request URI is too long for the application to handle.
    CGIHTTPResponseRequestURITooLong,
    /// The requested media type is not supported.
    CGIHTTPResponseUnsupportedMediaType,
    /// The requested data range is nit satisfiable.
    CGIHTTPResponseRequestedRangeNotSatisfiable,
    /// The expectation of the requirement failed to meet.
    CGIHTTPResponseExpectationFailed,
    
    /// The application crashed during processing the request.
    CGIHTTPResponseInternalServerError = 500,
    /// The requested method is not implemented.
    CGIHTTPResponseNotImplemented,
    /// The request cannot be forwarded.
    CGIHTTPResponseBadGateway,
    /// The requested service is not available.
    CGIHTTPResponseServiceUnavailable,
    /// The request forwarding timed out.
    CGIHTTPResponseGatewayTimeout,
    /// The requested HTTP ersion is not supported.
    CGIHTTPResponseHTTPVersionNotSupported,
};

enum
{
    /// The response is redacted.
    CGIHTTPResponseRedactedError,
    /// The request is rejected before a response is generated.
    CGIHTTPResponseRejectedError,
};

/**
 @brief     The HTTP response object.
 
 The CGIHTTPResponse object encapsulates the response data that is to be sent to
 the client.
 */
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

/**
 @brief     Set the response to a template page with subsitiutions.
 
 Load the response with a template page, loaded with substitutions from the
 dictionary. The substitution comes with a template like "{KEY}". Content
 is loaded from the substitutions dictionary.
 
 @param     template        Template page.
 @param     substitutions   Substitutions to be done on the template page.
 */
- (void)setResponseWithTemplatePage:(NSString *)template
                      substitutions:(NSDictionary *)substitutions;

/**
 Set the response to a page reporting a certain error, with the status code 500.
 
 @param     error           The error to be reported.
 */
- (void)setResponseWithError:(NSError *)error;

/**
 Set the response to a page reporting a certain error, with the given status
 code.
 
 @param     error           The error to be reported.
 @param     statusCode      The status code to be used.
 */
- (void)setResponseWithError:(NSError *)error
                  statusCode:(CGIHTTPResponseCode)statusCode;

/**
 Set the response to a page reporting a certain exception, with the status code
 500.
 
 @param     exception       The exception to be reported.
 */
- (void)setResponseWithException:(NSException *)exception;

/**
 Set the response to a HTTP redirection to a certain page, with the status code
 302.
 
 @param     target          The destinetion of redirection.
 */
- (void)setResponseWithRedirection:(NSString *)target;

/**
 Set the response to a HTTP redirection to a certain page, with the given status
 code.
 
 @param     target          The destinetion of redirection.
 @param     statusCode      The status code to be used.
 */
- (void)setResponseWithRedirection:(NSString *)target
                        statusCode:(CGIHTTPResponseCode)statusCode;

/**
 Set the response to an error page reporting a rejected request.
 
 @note      Generally you do not call this method directly, instead you return
            NO from the respective delegate method.
 */
- (void)setResponseWithRejectedRequest;

/**
 Set the response to an error page reporting a redacted response.
 
 @note      Generally you do not call this method directly, instead you return
            NO from the respective delegate method.
 */
- (void)setResponseWithRedactedResponse;

@end

#include <CGIKit/CGIHTTPResponseStrings.h>
