//
//  NSData+MSCompression.h
//  MSBooster
//
//  Created by Maxthon Chan on 8/16/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MSBooster/MSCommon.h>

typedef NS_ENUM(NSInteger, MSCompressionLevel)
{
    MSCompressionLevelNoCompression = 0,
    MSCompressionLevelBestSpeed = 1,
    MSCompressionLevelBestSize = 9,
    MSCompressionLevelDefault = -1
};

@interface NSData (MSCompression)

- (NSData *)zlibCompress;
- (NSData *)zlibCompressWithLevel:(MSCompressionLevel)level;
- (NSData *)zlibDecompress;

- (NSData *)gzipCompress;
- (NSData *)gzipCompressWithLevel:(MSCompressionLevel)level;
- (NSData *)gzipDecompress;

#if !TARGET_OS_IPHONE

// Sadly, we does not have libbz2 on iPhones.

- (NSData *)bzipCompress;
- (NSData *)bzipCompressWithLevel:(MSCompressionLevel)level;
- (NSData *)bzipDecompress;
#endif

@end
