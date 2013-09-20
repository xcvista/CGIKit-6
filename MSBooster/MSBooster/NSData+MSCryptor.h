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

@end
