//
//  NSData+MSCryptor.h
//  MSBooster
//
//  Created by Maxthon Chan on 9/20/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MSCryptorDelegate <NSObject>

@optional
- (void)data:(NSData *)data
     cryptor:(SEL)cryptor didProcessBytes:(NSUInteger)bytes;

@end

@interface NSData (MSCryptor)

/**
 Encrypt the data using 256-bit AES in CBC mode.
 
 @param     key         Cryptographic key.
 @param     initializer Initializer.
 @note      Key and initializer is SHA-256'd and MD5'd to match the lengths.
 */
- (NSData *)encryptUsingKey:(NSData *)key initializer:(NSData *)initializer;

/**
 Decrypt the data using 256-bit AES in CBC mode.
 
 @param     key         Cryptographic key.
 @param     initializer Initializer.
 @note      Key and initializer is SHA-256'd and MD5'd to match the lengths.
 */
- (NSData *)decryptUsingKey:(NSData *)key initializer:(NSData *)initializer;

@end

@interface NSData (MSCryptorContainer)

/**
 @brief     Generate a stream of random bytes.
 
 This method reads from /dev/urandom to obtain a stream of random bytes.
 
 @param     length      Length of the data object.
 */
+ (NSData *)randomDataWithLength:(NSUInteger)length;

@end
