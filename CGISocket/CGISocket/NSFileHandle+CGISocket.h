//
//  NSFileHandle+CGISocket.h
//  CGISocket
//
//  Created by Maxthon Chan on 10/10/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CGIHostAddress;

@interface NSFileHandle (CGISocket)

#pragma mark - send(2) and recv(2)

- (NSUInteger)sendBytes:(const void *)bytes length:(NSUInteger)length error:(inout NSError **)error;
- (NSUInteger)sendData:(NSData *)data error:(inout NSError **)error;

- (NSUInteger)receiveBytes:(void *)bytes length:(NSUInteger)preferredlength error:(inout NSError **)error;
- (NSData *)receiveDataWithLength:(NSUInteger)preferredLength error:(inout NSError **)error;

#pragma mark - sendTo(2) and recvFrom(2)

- (NSUInteger)sendBytes:(const void *)bytes length:(NSUInteger)length toAddress:(CGIHostAddress *)address error:(inout NSError **)error;
- (NSUInteger)sendData:(NSData *)data toAddress:(CGIHostAddress *)address error:(inout NSError **)error;

- (NSUInteger)receiveBytes:(void *)bytes length:(NSUInteger)length fromAddress:(inout CGIHostAddress **)address error:(inout NSError **)error;
- (NSData *)receiveDataWithLength:(NSUInteger)preferredLength fromAddress:(inout CGIHostAddress **)address error:(inout NSError **)error;

@end
