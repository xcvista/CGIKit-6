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
#import "NSData+MSCryptor.h"
#import "MSCommon.h"

@implementation NSData (MSTrivialCryptography)

- (NSData *)scrambleUsingKey:(NSData *)key
                 initializer:(NSData *)initializer
                    delegate:(id<MSCryptorDelegate>)delegate
{
    NSMutableData *dest = [NSMutableData dataWithLength:[self length]];
    
    @autoreleasepool
    {
        // Derive the initial vector from the key.
        NSData *keyHash = [key SHA512Hash];
        NSData *segmentKey = [initializer SHA512Hash];
        NSUInteger length = [keyHash length];
        NSRange segmentRange = NSMakeRange(0, 0);
        
#ifndef GNUSTEP
        dispatch_group_t group = dispatch_group_create(); // Parallelized on OS X
#else
        char *obuf = malloc(length);
#endif
        
        volatile register __block NSUInteger processed = 0;
        
        do
        {
            @autoreleasepool
            {
                // Snap off vector-lengthed source segment.
                NSUInteger segmentStart = NSMaxRange(segmentRange);
                NSUInteger segmentLength = MIN(length, [self length] - segmentStart);
                if (!segmentLength)
                    break;
                
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
                    NSUInteger processed2 = ++processed;
                    
                    if ([delegate respondsToSelector:@selector(data:cryptor:didProcessBytes:)])
                        [delegate data:self
                               cryptor:_cmd
                       didProcessBytes:MIN(processed2 * length, [self length])];
#ifndef GNUSTEP
                    free(obuf);
                });
#endif
            }
        } while (segmentRange.length);
        
#ifndef GNUSTEP
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
#else
        free(obuf);
#endif
    }
    
    return [NSData dataWithData:dest];
}

@end
