//
//  NSData+MSTrivialCryptography.m
//  MSBooster
//
//  Created by Maxthon Chan on 9/19/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "NSData+MSTrivialCryptography.h"
#import "NSData+MSHashing.h"
#import "NSData+MSHMAC.h"
#import "NSData+MSCompression.h"

#import "MSCommon.h"

#if __has_include(<Accelerate/Accelerate.h>)
#define USE_SIMD
#import <Accelerate/Accelerate.h>
#endif

@implementation NSData (MSTrivialCryptography)

- (NSData *)scrambleUsingKey:(NSData *)key initializer:(NSData *)initializer
{
    // Derive the initial vector from the key.
    NSData *keyHash = [key SHA512Hash];
    NSData *segmentKey = [initializer SHA512Hash];
    NSUInteger length = [keyHash length];
    
    NSMutableData *source = [NSMutableData dataWithData:self];
    NSMutableData *dest = [NSMutableData dataWithCapacity:[self length]];
    
    void *obuf = malloc(length);
    
    do
    {
        // Snap off vector-lengthed source segment.
        NSRange segmentRange = NSMakeRange(0, MIN(length, [source length]));
        NSData *segment = [source subdataWithRange:segmentRange];
        [source replaceBytesInRange:segmentRange withBytes:NULL length:0];
        
        // Derive a key
        segmentKey = [segmentKey SHA512HMAC:keyHash];
        
        // XOR bytes
        const char *sp = (const char *)[segment bytes];
        const char *kp = (const char *)[segmentKey bytes];
        char *dp = (char *)obuf;
        for (NSUInteger i = 0; i < segmentRange.length; i++)
        {
            *dp = *sp ^ *kp;
            dp++, sp++, kp++;
        }
        
        [dest appendBytes:obuf length:segmentRange.length];
    } while ([source length]);
    
    free(obuf);
    
    return [NSData dataWithData:dest];
}

+ (NSData *)randomDataWithLength:(NSUInteger)length
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:@"/dev/urandom"];
    return [handle readDataOfLength:length];
}

- (NSData *)scrambleUsingKey:(NSData *)key
{
    // Generate an initializer.
    NSData *initializer = [NSData randomDataWithLength:128];
    NSData *ciphertext = [self scrambleUsingKey:key initializer:initializer];
    NSData *package = [NSPropertyListSerialization dataWithPropertyList:@[initializer, ciphertext]
                                                                 format:NSPropertyListBinaryFormat_v1_0
                                                                options:0
                                                                  error:NULL];
    return [package gzipCompress];
}

- (NSData *)descrambleUsingKey:(NSData *)key
{
    NSData *decompressed = [self gzipDecompress];
    if (!decompressed)
        return nil;
    
    NSArray *package = [NSPropertyListSerialization propertyListWithData:decompressed
                                                                 options:0
                                                                  format:NULL
                                                                   error:NULL];
    if (![package isKindOfClass:[NSArray class]] || [package count] < 2)
        return nil;
    
    NSData *initializer = package[0];
    NSData *ciphertext = package[1];
    
    return [ciphertext scrambleUsingKey:key initializer:initializer];
}

@end
