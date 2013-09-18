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
 A trivial stream cipher implementation based on a CSPRNG implemented on top of
 SHA-512 and XOR as stream cipher function. This method will decrypt itself when
 called on the encrypted NSObject with the same key object.
 
 @warning   There is no guarantee on the strength and effectiveness of this
            cipher. Use at your own risk, and use a real cipher on real deals.
 */
- (NSData *)scrambleUsingKey:(NSData *)key;

@end
