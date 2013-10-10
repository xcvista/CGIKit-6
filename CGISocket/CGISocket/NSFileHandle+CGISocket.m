//
//  NSFileHandle+CGISocket.m
//  CGISocket
//
//  Created by Maxthon Chan on 10/10/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "NSFileHandle+CGISocket.h"

#import "CGIHostAddress.h"
#import <sys/socket.h>
#import <MSBooster/MSBooster.h>

@implementation NSFileHandle (CGISocket)

- (NSUInteger)sendBytes:(const void *)bytes length:(NSUInteger)length error:(inout NSError *__autoreleasing *)error
{
    errno = 0;
    ssize_t rv = send([self fileDescriptor], bytes, length, 0);
    
    if (rv < 0)
    {
        MSAssignPointer(error, [NSError errorWithDomain:NSPOSIXErrorDomain code:errno userInfo:nil]);
        return 0;
    }
    return rv;
}

- (NSUInteger)sendData:(NSData *)data error:(inout NSError *__autoreleasing *)error
{
    return [self sendBytes:[data bytes] length:[data length] error:error];
}

- (NSUInteger)receiveBytes:(void *)bytes length:(NSUInteger)preferredlength error:(inout NSError *__autoreleasing *)error
{
    errno = 0;
    ssize_t rv = recv([self fileDescriptor], bytes, preferredlength, 0);
    
    if (rv < 0)
    {
        MSAssignPointer(error, [NSError errorWithDomain:NSPOSIXErrorDomain code:errno userInfo:nil]);
        return 0;
    }
    
    return rv;
}

- (NSData *)receiveDataWithLength:(NSUInteger)preferredLength error:(inout NSError *__autoreleasing *)error
{
    NSMutableData *data = [NSMutableData dataWithLength:preferredLength];
    if (!data)
        return nil;
    
    NSUInteger rv = [self receiveBytes:[data mutableBytes] length:[data length] error:error];
    
    if (rv > 0)
    {
        [data setLength:rv];
        return [NSData dataWithData:data];
    }
    else
    {
        return nil;
    }
}

- (NSUInteger)sendBytes:(const void *)bytes length:(NSUInteger)length toAddress:(CGIHostAddress *)address error:(inout NSError *__autoreleasing *)error
{
    errno = 0;
    
    ssize_t rv = sendto([self fileDescriptor], bytes, length, 0, [address address], [address size]);
    
    if (rv < 0)
    {
        MSAssignPointer(error, [NSError errorWithDomain:NSPOSIXErrorDomain code:errno userInfo:nil]);
        return 0;
    }
    return rv;
}

- (NSUInteger)sendData:(NSData *)data toAddress:(CGIHostAddress *)address error:(inout NSError *__autoreleasing *)error
{
    return [self sendBytes:[data bytes] length:[data length] toAddress:address error:error];
}

- (NSUInteger)receiveBytes:(void *)bytes length:(NSUInteger)length fromAddress:(inout CGIHostAddress *__autoreleasing *)address error:(inout NSError *__autoreleasing *)error
{
    errno = 0;
    
    struct sockaddr *addr = malloc(BUFSIZ);
    socklen_t size = 0;
    
    ssize_t rv = recvfrom([self fileDescriptor], bytes, length, 0, addr, &size);
    if (rv < 0)
    {
        MSAssignPointer(error, [NSError errorWithDomain:NSPOSIXErrorDomain code:errno userInfo:nil]);
        return 0;
    }
    MSAssignPointer(address, [[CGIHostAddress alloc] initWithAddress:addr size:size]);
    free(addr);
    return rv;
}

- (NSData *)receiveDataWithLength:(NSUInteger)preferredLength fromAddress:(inout CGIHostAddress *__autoreleasing *)address error:(inout NSError *__autoreleasing *)error
{
    NSMutableData *data = [NSMutableData dataWithLength:preferredLength];
    if (!data)
        return nil;
    
    NSUInteger rv = [self receiveBytes:[data mutableBytes] length:[data length] fromAddress:address error:error];
    
    if (rv > 0)
    {
        [data setLength:rv];
        return [NSData dataWithData:data];
    }
    else
    {
        return nil;
    }
}

@end
