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

@implementation NSData (MSTrivialCryptography)

- (NSData *)scrambleUsingKey:(NSData *)key
{
    // Derive the initial vector from the key.
    NSData *vector = [key SHA512Hash];
    NSData *segmentKey = vector;
    NSUInteger length = [vector length];
    
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
        segmentKey = [segmentKey SHA512HMAC:vector];
        
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

@end
