//
//  NSData+MSCryptor.m
//  MSBooster
//
//  Created by Maxthon Chan on 9/20/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "NSData+MSCryptor.h"
#import "NSData+MSHashing.h"
#import "NSData+MSCompression.h"
#import "NSData+MSHMAC.h"
#import "NSData+MSTrivialCryptography.h"

#if !__has_include(<CommonCrypto/CommonCrypto.h>)
#define USE_CC
#import <CommonCrypto/CommonCryptor.h>
#else
#import <openssl/aes.h>
#import <openssl/crypto.h>
#warning Tests on OS X tells that this OpenSSL-based impleentation is flawed.
#endif

#define AES128_BLOCK_SIZE (16)

@implementation NSData (MSCryptor)

+ (void)load
{
#ifndef USE_CC
    ERR_load_CRYPTO_strings();
#endif
}

- (NSData *)AESEncryptWithKey:(NSData *)key
{
    // Minimum length requirement
    if ([self length] < AES128_BLOCK_SIZE || [key length] < AES128_BLOCK_SIZE)
        return nil;
    
    size_t key_size = [key length];
    
    if (key_size >= 32)
        key_size = 32;
    else if (key_size >= 24)
        key_size = 24;
    else
        key_size = 16;
    
    char *block = malloc(AES128_BLOCK_SIZE);
    char *key_buffer = malloc(key_size);
    char *output_block = malloc(AES128_BLOCK_SIZE);;
    
    if (!block || !key_buffer || !output_block)
    {
        if (block)
            free(block);
        if (key_buffer)
            free(key_buffer);
        if (output_block)
            free(output_block);
        
        return nil;
    }
    
    [self getBytes:block length:AES128_BLOCK_SIZE];
    [key getBytes:key_buffer length:key_size];
    
#ifdef USE_CC
    
    
    if (CCCrypt(kCCEncrypt,
                kCCAlgorithmAES,
                kCCOptionECBMode,
                key_buffer,
                key_size,
                NULL,
                block,
                AES128_BLOCK_SIZE,
                output_block,
                AES128_BLOCK_SIZE,
                NULL) != kCCSuccess)
    {
        free(block);
        free(key_buffer);
        free(output_block);
        return nil;
    }
#else
    AES_KEY AES_key;
    AES_set_encrypt_key((void *)key_buffer, (int)key_size, &AES_key);
    AES_encrypt((void *)block, (void *)output_block, &AES_key);
#endif
    
    free(block);
    free(key_buffer);
    return [NSData dataWithBytesNoCopy:output_block length:AES128_BLOCK_SIZE freeWhenDone:YES];
}

- (NSData *)AESDecryptWithKey:(NSData *)key
{
    // Minimum length requirement
    if ([self length] < AES128_BLOCK_SIZE || [key length] < AES128_BLOCK_SIZE)
        return nil;
    
    size_t key_size = [key length];
    
    if (key_size >= 32)
        key_size = 32;
    else if (key_size >= 24)
        key_size = 24;
    else
        key_size = 16;
    
    char *block = malloc(AES128_BLOCK_SIZE);
    char *key_buffer = malloc(key_size);
    char *output_block = malloc(AES128_BLOCK_SIZE);;
    
    if (!block || !key_buffer || !output_block)
    {
        if (block)
            free(block);
        if (key_buffer)
            free(key_buffer);
        if (output_block)
            free(output_block);
        
        return nil;
    }
    
    [self getBytes:block length:AES128_BLOCK_SIZE];
    [key getBytes:key_buffer length:key_size];
    
#ifdef USE_CC
    
    
    if (CCCrypt(kCCDecrypt,
                kCCAlgorithmAES,
                kCCOptionECBMode,
                key_buffer,
                key_size,
                NULL,
                block,
                AES128_BLOCK_SIZE,
                output_block,
                AES128_BLOCK_SIZE,
                NULL) != kCCSuccess)
    {
        free(block);
        free(key_buffer);
        free(output_block);
        return nil;
    }
#else
    AES_KEY AES_key;
    AES_set_decrypt_key((void *)key_buffer, (int)key_size, &AES_key);
    AES_decrypt((void *)block, (void *)output_block, &AES_key);
#endif
    
    free(block);
    free(key_buffer);
    return [NSData dataWithBytesNoCopy:output_block length:AES128_BLOCK_SIZE freeWhenDone:YES];
}

- (NSData *)xorWithData:(NSData *)data
{
    size_t length = MIN([self length], [data length]);
    char *s = malloc(length);
    char *k = malloc(length);
    char *d = malloc(length);
    
    if (!(s && k && d))
    {
        if (s)
            free(s);
        if (k)
            free(k);
        if (d)
            free(d);
        
        return nil;
    }
    
    [self getBytes:s length:length];
    [data getBytes:k length:length];
    
    char *sp = s, *dp = d, *kp = k;
    size_t block_count = length / sizeof(size_t);
    
    for (size_t i = 0; i < block_count; i++)
    {
        size_t *bsp = (size_t *)sp, *bdp = (size_t *)dp, *bkp = (size_t *)kp;
        *bdp = *bsp ^ *bkp;
        sp += sizeof(size_t);
        dp += sizeof(size_t);
        kp += sizeof(size_t);
    }
    
    for (; sp - s < length; sp++, dp++, kp++)
    {
        *dp = *sp ^ *kp;
    }
    
    free(s);
    free(k);
    
    return [NSData dataWithBytesNoCopy:d length:length freeWhenDone:YES];
}

- (NSData *)gzipPaddingToBoundry:(NSUInteger)boundry
{
    NSMutableData *gzipped = [NSMutableData dataWithData:[self gzipCompress]];
    
    if ([gzipped length] % boundry != 0)
    {
        NSUInteger targetLength = ([gzipped length] / boundry + 1);
        NSUInteger paddingLength = targetLength - [gzipped length];
        NSData *padding = [NSData randomDataWithLength:paddingLength];
        [gzipped appendData:padding];
    }
    
    return [NSData dataWithData:gzipped];
}

@end

@implementation NSData (MSCryptorContainer)

+ (NSData *)randomDataWithLength:(NSUInteger)length
{
    @autoreleasepool
    {
        NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:@"/dev/urandom"];
        NSData *key = [handle readDataOfLength:64];
        NSData *IV = [handle readDataOfLength:64];
        NSData *data = [handle readDataOfLength:length];
        return [data scrambleUsingKey:key initializer:IV delegate:nil];
    }
}

@end
