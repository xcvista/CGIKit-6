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

#if __has_include(<CommonCrypto/CommonCrypto.h>)
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

- (NSData *)encryptUsingKey:(NSData *)key initializer:(NSData *)initializer
{
    NSData *result = nil;
    @autoreleasepool
    {
        NSData *IV = [initializer MD5Hash]; // Hash to match the length of AES IV.
        NSData *hkey = [initializer SHA256Hash]; // Hash to match the length of AES key.
        
        // Gzip the data and pad it up to AES block boundry.
        NSMutableData *data = [NSMutableData dataWithData:[self gzipCompress]];
        NSUInteger targetLength = ([data length] / AES128_BLOCK_SIZE + 1) * AES128_BLOCK_SIZE;
        NSData *padding = [NSData randomDataWithLength:targetLength - [data length]];
        [data appendData:padding];
        padding = nil; // Release padding which is of no use now.
        
        void *buffer = malloc([data length]);
        if (!buffer)
            return nil;
        
#ifdef USE_CC
        if (CCCrypt(kCCEncrypt,
                    kCCAlgorithmAES,
                    0,
                    [hkey bytes],
                    [hkey length],
                    [IV bytes],
                    [data bytes],
                    [data length],
                    buffer,
                    targetLength,
                    NULL) != kCCSuccess)
        {
            free(buffer);
            return nil;
        }
#else
        AES_KEY aes_key;
        unsigned char *iv = malloc([IV length]);
        [IV getBytes:iv];
        
        AES_set_encrypt_key([hkey bytes], (int)[hkey length], &aes_key);
        AES_cbc_encrypt([data bytes],
                        buffer,
                        [data length],
                        &aes_key,
                        iv,
                        AES_ENCRYPT);
#endif
        result = [NSData dataWithBytesNoCopy:buffer
                                      length:[data length]
                                freeWhenDone:YES];
    }
    return result;
}

- (NSData *)decryptUsingKey:(NSData *)key initializer:(NSData *)initializer
{
    NSData *result = nil;
    @autoreleasepool
    {
        NSData *IV = [initializer MD5Hash]; // Hash to match the length of AES IV.
        NSData *hkey = [initializer SHA256Hash]; // Hash to match the length of AES key.
        
        void *buffer = malloc([self length]);
        if (!buffer)
            return nil;
        
#ifdef USE_CC
        if (CCCrypt(kCCDecrypt,
                    kCCAlgorithmAES,
                    0,
                    [hkey bytes],
                    [hkey length],
                    [IV bytes],
                    [self bytes],
                    [self length],
                    buffer,
                    [self length],
                    NULL) != kCCSuccess)
        {
            free(buffer);
            return nil;
        }
#else
        AES_KEY aes_key;
        unsigned char *iv = malloc([IV length]);
        [IV getBytes:iv];
        
        AES_set_decrypt_key([hkey bytes], (int)[hkey length], &aes_key);
        AES_cbc_encrypt([self bytes],
                        buffer,
                        [self length],
                        &aes_key,
                        iv,
                        AES_DECRYPT);
#endif
        result = [NSData dataWithBytesNoCopy:buffer
                                      length:[self length]
                                freeWhenDone:YES];
    }
    return [result gzipDecompress];
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
