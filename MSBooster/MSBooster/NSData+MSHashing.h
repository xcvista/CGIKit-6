//
//  NSData+MSHashing.h
//  MSBooster
//
//  Created by Maxthon Chan on 8/16/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (MSHashing)

- (NSData *)MD4Hash;
- (NSData *)MD5Hash;
- (NSData *)SHA1Hash;
- (NSData *)SHA224Hash;
- (NSData *)SHA256Hash;
- (NSData *)SHA384Hash;
- (NSData *)SHA512Hash;

@end
