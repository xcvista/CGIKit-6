//
//  NSData+MSHashing.m
//  MSBooster
//
//  Created by Maxthon Chan on 8/16/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "NSData+MSHashing.h"
#if __has_include(<CommonCrypto/CommonCrypto.h>)
#define COMMON_DIGEST_FOR_OPENSSL
#import <CommonCrypto/CommonCrypto.h>
#define _MB_CC_FUNC(_name) CC_##_name
#define _MB_CC_TYPE CC_LONG
typedef unsigned char *(*_MS_CryptoFunction)(const void *, CC_LONG, unsigned char *);
#else
#import <openssl/sha.h>
#import <openssl/md2.h>
#import <openssl/md4.h>
#import <openssl/md5.h>
#define _MB_CC_FUNC(_name) _name
#define _MB_CC_TYPE size_t
typedef unsigned char *(*_MS_CryptoFunction)(const unsigned char *, size_t, unsigned char *);
#endif

#ifndef SHA1_DIGEST_LENGTH
#define SHA1_DIGEST_LENGTH SHA_DIGEST_LENGTH
#endif

#import "MSCommon.h"

MSInline NSData *_MS_ComputeHash(NSData *self, _MB_CC_TYPE digestSize, _MS_CryptoFunction function)
{
    void *buf = malloc(digestSize);
    if (!buf)
        return nil;
    
    if (!function([self bytes], (_MB_CC_TYPE)[self length], buf))
    {
        free(buf);
        return nil;
    }
    
    return [NSData dataWithBytesNoCopy:buf length:digestSize freeWhenDone:YES];
}

#define _MS_HashMethod(_function) - (NSData *)_function##Hash { return _MS_ComputeHash(self, _function##_DIGEST_LENGTH, _MB_CC_FUNC(_function)); }

@implementation NSData (MSHashing)

_MS_HashMethod(MD4);
_MS_HashMethod(MD5);
_MS_HashMethod(SHA1);
_MS_HashMethod(SHA224);
_MS_HashMethod(SHA256);
_MS_HashMethod(SHA384);
_MS_HashMethod(SHA512);

@end
