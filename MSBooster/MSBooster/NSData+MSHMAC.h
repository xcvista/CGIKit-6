//
//  NSData+MSHMAC.h
//  MSBooster
//
//  Created by Maxthon Chan on 9/19/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (MSHMAC)

/**
 Calculates the MD5 HMAC.
 */
- (NSData *)MD5HMAC:(NSData *)key;

/**
 Calculates the SHA-1 HMAC.
 */
- (NSData *)SHA1HMAC:(NSData *)key;

/**
 Calculates the SHA-224 HMAC.
 */
- (NSData *)SHA224HMAC:(NSData *)key;

/**
 Calculates the SHA-256 HMAC.
 */
- (NSData *)SHA256HMAC:(NSData *)key;

/**
 Calculates the SHA-384 HMAC.
 */
- (NSData *)SHA384HMAC:(NSData *)key;

/**
 Calculates the SHA-512 HMAC.
 */
- (NSData *)SHA512HMAC:(NSData *)key;

@end
