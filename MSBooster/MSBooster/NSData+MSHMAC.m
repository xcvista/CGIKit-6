//
//  NSData+MSHMAC.m
//  MSBooster
//
//  Created by Maxthon Chan on 9/19/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "NSData+MSHMAC.h"
#if __has_include(<CommonCrypto/CommonCrypto.h>)
#define CC_OK
#define COMMON_DIGEST_FOR_OPENSSL
#import <CommonCrypto/CommonCrypto.h>
typedef CCHmacAlgorithm MSHMACAlgorithm;
#define MSHMACSHA1 kCCHmacAlgSHA1
#define MSHMACMD5 kCCHmacAlgMD5
#define MSHMACSHA256 kCCHmacAlgSHA256
#define MSHMACSHA384 kCCHmacAlgSHA384
#define MSHMACSHA512 kCCHmacAlgSHA512
#define MSHMACSHA224 kCCHmacAlgSHA224
#else
#import <openssl/sha.h>
#import <openssl/md2.h>
#import <openssl/md4.h>
#import <openssl/md5.h>
#import <openssl/hmac.h>
typedef const EVP_MD *MSHMACAlgorithm;
#define MSHMACSHA1 EVP_sha1()
#define MSHMACMD5 EVP_md5()
#define MSHMACSHA256 EVP_sha256()
#define MSHMACSHA384 EVP_sha384()
#define MSHMACSHA512 EVP_sha512()
#define MSHMACSHA224 EVP_sha224()
#endif

#ifndef SHA1_DIGEST_LENGTH
#define SHA1_DIGEST_LENGTH SHA_DIGEST_LENGTH // Why this is not in the standard header?
#endif

#import "MSCommon.h"

MSInline NSData *MSHMAC(NSData *self, MSHMACAlgorithm algorithm, NSData *key, NSUInteger length)
{
    void *output = malloc(128);
#ifdef CC_OK
    CCHmac(algorithm,
           [key bytes],
           [key length],
           [self bytes],
           [self length],
           output);
#else
    HMAC(algorithm,
         [key bytes],
         (int)[key length],
         [self bytes],
         (int)[self length],
         output,
         NULL);
#endif
    NSData *d = [NSData dataWithBytes:output length:length];
    free(output);
    return d;
}

#define MSHMACMethod(_func) - (NSData *)_func##HMAC:(NSData *)key { return MSHMAC(self, MSHMAC##_func, key, _func##_DIGEST_LENGTH); }

@implementation NSData (MSHMAC)

MSHMACMethod(MD5)
MSHMACMethod(SHA1)
MSHMACMethod(SHA224)
MSHMACMethod(SHA256)
MSHMACMethod(SHA384)
MSHMACMethod(SHA512)

@end
