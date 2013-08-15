/**
 @file      CGIRemoteConnection.h
 @author    Maxthon Chan
 @date      May. 21, 2013
 @copyright Copyright (c) 2013 muski. All rights reserved.
 */

#import <Foundation/Foundation.h>

/**
 HTTP 错误域。
 */
extern NSString *const CGIHTTPErrorDomain __attribute__((weak));

/**
 服务器地址根键。
 */
extern NSString *const CGIRemoteConnectionServerRootKey;

@class CGIRemoteConnection;

@protocol CGIRemoteConnectionDelegate <NSObject>

@optional

- (BOOL)connection:(CGIRemoteConnection *)connection shouldSendURLRequset:(NSURLRequest *)request;

@end

/**
 远程连接控制对象。
 */
@interface CGIRemoteConnection : NSObject

/**
 服务器地址根。
 
 @note      格式如下：http://server/path/to/script?%@，也即，以“%@”作为方法名
            占位符。
 @see       -initWithServerRoot:
 */
@property NSString *serverRoot;

@property id<CGIRemoteConnectionDelegate> delegate;

/**
 获得默认远程连接控制对象。
 
 @return    默认远程连接控制对象。
 @see       -makeDefaultServerRoot
 */
+ (instancetype)defaultRemoteConnection;

/**
 以指定的服务器根地址初始化远程连接控制对象。
 
 @param     serverRoot  服务器根地址。
 @return    初始化的远程连接控制对象。
 @see       serverRoot
 */
- (id)initWithServerRoot:(NSString *)serverRoot;

/**
 使当前对象成为默认远程连接对象。
 
 @see       +defaultRemoteConnection
 */
- (void)makeDefaultServerRoot;

/**
 向指定远程方法发送请求数据，并得到返回数据。
 
 @param     data    请求数据。
 @param     method  远程方法名。
 @param     error   如果调用失败，指针所指向的对象将被修改为错误的详细信息。您可
                    传入 NULL 屏蔽这一输出。
 */
- (NSData *)dataWithData:(NSData *)data
              fromMethod:(NSString *)method
                   error:(NSError *__autoreleasing *)error;

/**
 获取用户代理字符串。
 
 @return    用户代理字符串。
 */
- (NSString *)userAgent;

/**
 从方法名得到 URL 请求对象。
 
 @param     method  远程方法名。
 @return    URL 请求对象。
 */
- (NSMutableURLRequest *)URLRequestForMethod:(NSString *)method;

- (BOOL)connectionShouldSendURLRequest:(NSURLRequest *)request;

@end
