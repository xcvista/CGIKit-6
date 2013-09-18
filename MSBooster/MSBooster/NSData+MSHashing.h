//
//  NSData+MSHashing.h
//  MSBooster
//
//  Created by Maxthon Chan on 8/16/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (MSHashing)

/**
 Calculates MD4 hash of the object.
 
 @warning   MD4 hash is cryptographically broken. Please use some alternative
            like SHA-2.
 */
- (NSData *)MD4Hash;

/**
 Calculates MD5 hash of the object.
 
 @warning   MD5 hash is cryptographically broken. Please use some alternative
            like SHA-2.
 */
- (NSData *)MD5Hash;

/**
 Calculates SHA-1 has of the object.
 
 @warning   SHA-1 hash is cryptographically broken. Please use some alternative
            like SHA-2.
 */
- (NSData *)SHA1Hash;

/**
 Calculates SHA-224 hash of the object.
 
 @note      SHA-224 is a member of the SHA-2 family of algorithms.
 */
- (NSData *)SHA224Hash;

/**
 Calculates SHA-256 hash of the object.
 
 @note      SHA-256 is a member of the SHA-2 family of algorithms.
 */
- (NSData *)SHA256Hash;

/**
 Calculates SHA-384 hash of the object.
 
 @note      SHA-384 is a member of the SHA-2 family of algorithms.
 */
- (NSData *)SHA384Hash;

/**
 Calculates SHA-512 hash of the object.
 
 @note      SHA-512 is a member of the SHA-2 family of algorithms.
 */
- (NSData *)SHA512Hash;

@end
