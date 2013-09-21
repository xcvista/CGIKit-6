/**
 @file      CGIRemoteConnection.h
 @author    Maxthon Chan
 @date      May. 21, 2013
 @copyright Copyright (c) 2013 muski. All rights reserved.
 */

#import <Foundation/Foundation.h>

/**
 HTTP error domain.
 */
extern NSString *const CGIHTTPErrorDomain __attribute__((weak));

/**
 Server root key.
 */
extern NSString *const CGIRemoteConnectionServerRootKey;

@class CGIRemoteConnection;

@protocol CGIRemoteConnectionDelegate <NSObject>

@optional

- (BOOL)connection:(CGIRemoteConnection *)connection shouldSendURLRequset:(NSMutableURLRequest *)request;

@end

/**
 CGIRemoteConnection object controls the remote connection
 */
@interface CGIRemoteConnection : NSObject

/**
 Serer address root.
 
 The format of this string should be like: http://server/path/to/script?%@ -
 that is, use %@ as a placeholder of the method name.
 
 @see       -initWithServerRoot:
 */
@property NSString *serverRoot;

/**
 Connection delegate.
 */
@property id<CGIRemoteConnectionDelegate> delegate;

/**
 Get the default remote connection object.
 
 @return    The default remote connection object.
 @see       -makeDefaultServerRoot
 */
+ (instancetype)defaultRemoteConnection;

/**
 Initialize the connection with a given address root.
 
 @param     serverRoot  Server address root.
 @see       serverRoot
 */
- (id)initWithServerRoot:(NSString *)serverRoot;

/**
 Make the receiver the default remote connection.
 
 @see       +defaultRemoteConnection
 */
- (void)makeDefaultServerRoot;

/**
 Send data to the remote service, asking for response data.
 
 @param     data    Request data
 @param     method  Name of the remote method
 @param     error   If the call fails, this pointer will point to an object
                    telling the reason of failure.
 */
- (NSData *)dataWithData:(NSData *)data
              fromMethod:(NSString *)method
                   error:(NSError *__autoreleasing *)error;

/**
 Get the user agent string.
 */
- (NSString *)userAgent;

/**
 Get the URL request from name of the method.
 
 @param     method  Name of the method
 */
- (NSMutableURLRequest *)URLRequestForMethod:(NSString *)method;

/**
 Ask the delegate if the request should be sent.
 */
- (BOOL)connectionShouldSendURLRequest:(NSMutableURLRequest *)request;

@end
