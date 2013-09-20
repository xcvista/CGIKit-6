//
//  NSData+MSTrivialCryptography.h
//  MSBooster
//
//  Created by Maxthon Chan on 9/19/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MSCryptorDelegate;

@interface NSData (MSTrivialCryptography)

/**
 @brief     A trivial stream cipher.
 
 This cipher is a stream cipher constructed by running SHA-512 HMAC, a keyed
 hash algorithm, in output-feedback mode.
 
 When this method is called on the result of this methhod with the same key, its
 effect is reversed. (i.e. it decrypts itself.)
 
 @warning   There is no guarantee on the strength and effectiveness of this toy
            cipher. Use at your own risk, and use a real cipher on real deals.
            Also, it is quite slow.
 
 @param     key         Cryptography key.
 @param     initializer Initializer
 @param     delegate    Cryptor delegate
 @note      Key and initializer are SHA-512'd internally to match the lengths.
 */
- (NSData *)scrambleUsingKey:(NSData *)key initializer:(NSData *)initializer delegate:(id<MSCryptorDelegate>)delegate;

@end
