//
//  NSData+MSTrivialCryptography.h
//  MSBooster
//
//  Created by Maxthon Chan on 9/19/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (MSTrivialCryptography)

/**
 @brief     A trivial stream cipher.
 
 This cipher is a stream cipher constructed by running SHA-512 HMAC, a keyed
 hash algorithm, in output-feedback mode. Both initializing vector and crypto
 key is derived from the input key object.
 
 When this method is called on the result of this methhod with the same key, its
 effect is reversed. (i.e. it decrypts itself.)
 
 @warning   There is no guarantee on the strength and effectiveness of this toy
            cipher. Use at your own risk, and use a real cipher on real deals.
            Also, it is quite slow.
 */
- (NSData *)scrambleUsingKey:(NSData *)key;

@end
