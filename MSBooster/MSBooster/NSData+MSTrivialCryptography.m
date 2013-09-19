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
    
    NSMutableData *dest = [NSMutableData dataWithLength:[self length]];
    NSRange segmentRange = NSMakeRange(0, 0);
    
#ifndef GNUSTEP
    dispatch_group_t group = dispatch_group_create(); // Parallelized on OS X
#else
    char *obuf = malloc(length);
#endif
    
    do
    {
        // Snap off vector-lengthed source segment.
        NSUInteger segmentStart = NSMaxRange(segmentRange);
        NSUInteger segmentLength = MIN(length, [self length] - segmentStart);
        segmentRange = NSMakeRange(segmentStart, segmentLength);
        NSData *segment = [self subdataWithRange:segmentRange];
        
        // Derive a key
        segmentKey = [segmentKey SHA512HMAC:keyHash];
        
        // XOR bytes
#ifndef GNUSTEP
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            char *obuf = malloc(length);
#endif
            const char *sp = (const char *)[segment bytes];
            const char *kp = (const char *)[segmentKey bytes];
            char *dp = obuf;
            for (NSUInteger i = 0; i < segmentRange.length; i++)
            {
                *dp = *sp ^ *kp;
                dp++, sp++, kp++;
            }
            [dest replaceBytesInRange:segmentRange withBytes:obuf];
#ifndef GNUSTEP
            free(obuf);
        });
#endif
    } while (segmentRange.length);
    
#ifndef GNUSTEP
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
#else
    free(obuf);
#endif
    
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
    NSData *MAC = [ciphertext SHA512HMAC:key];
    NSData *package = [NSPropertyListSerialization dataWithPropertyList:@[initializer, ciphertext, MAC]
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
    NSData *MAC = package[2];
    NSData *MAC2 = [ciphertext SHA512HMAC:key];
    
    if (![MAC isEqualToData:MAC2])
        return nil;
    
    return [ciphertext scrambleUsingKey:key initializer:initializer];
}

@end
