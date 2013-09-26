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
     cryptor:(SEL)cryptor didProcessBytes:(NSUInteger)bytes totalBytes:(NSUInteger)length;

@end

@interface NSData (MSCryptor)

/// Encrypt a block of AES data.
- (NSData *)AESEncryptBlockWithKey:(NSData *)key;
/// Decrypt a block of AES data.
- (NSData *)AESDecryptBlockWithKey:(NSData *)key;

/**
 AES PCBC encryption.
 
 This method includes internal hashing of keys, initializers and padding.
 */
- (NSData *)AESEncryptWithKey:(NSData *)key
                  initializer:(NSData *)initializer
                     delegate:(id<MSCryptorDelegate>)delegate;

/**
 AES PCBC decryption.
 */
- (NSData *)AESDecryptWithKey:(NSData *)key
                  initializer:(NSData *)initializer
                     delegate:(id<MSCryptorDelegate>)delegate;

/**
 AES OFB encryption/decryption
 */
- (NSData *)AESScrambleStreamWithKey:(NSData *)key
                         initializer:(NSData *)initializer
                            delegate:(id<MSCryptorDelegate>)delegate;

- (NSData *)xorWithData:(NSData *)data;

- (NSData *)gzipPaddingToBoundry:(NSUInteger)boundry;

@end

@interface NSData (MSCryptorContainer)

/**
 @brief     Generate a stream of random bytes.
 
 This method reads from /dev/urandom to obtain a stream of random bytes.
 
 @param     length      Length of the data object.
 */
+ (NSData *)randomDataWithLength:(NSUInteger)length;

@end
