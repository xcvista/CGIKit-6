//
//  NSData+MSCompression.m
//  MSBooster
//
//  Created by Maxthon Chan on 8/16/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "NSData+MSCompression.h"
#import <zlib.h>

#if !TARGET_OS_IPHONE
#import <bzlib.h>
#endif

@implementation NSData (MSCompression)

- (NSData *)zlibCompress
{
    return [self zlibCompressWithLevel:MSCompressionLevelDefault];
}

- (NSData *)zlibCompressWithLevel:(MSCompressionLevel)level
{
    if ([self length] == 0) return self;
    
    z_stream strm;
    
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.total_out = 0;
    strm.next_in=(Bytef *)[self bytes];
    strm.avail_in = (uInt)[self length];
    
    // Compresssion Levels:
    //   Z_NO_COMPRESSION
    //   Z_BEST_SPEED
    //   Z_BEST_COMPRESSION
    //   Z_DEFAULT_COMPRESSION
    
    if (deflateInit(&strm, level) != Z_OK) return nil;
    
    NSMutableData *compressed = [NSMutableData dataWithLength:16384];  // 16K chuncks for expansion
    
    do {
        
        if (strm.total_out >= [compressed length])
            [compressed increaseLengthBy: 16384];
        
        strm.next_out = [compressed mutableBytes] + strm.total_out;
        strm.avail_out = (uInt)([compressed length] - strm.total_out);
        
        deflate(&strm, Z_FINISH);
        
    } while (strm.avail_out == 0);
    
    deflateEnd(&strm);
    
    [compressed setLength: strm.total_out];
    return [NSData dataWithData: compressed];
}

- (NSData *)zlibDecompress
{
    if ([self length] == 0) return self;
    
    NSUInteger full_length = [self length];
    NSUInteger half_length = [self length] / 2;
    
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    
    z_stream strm;
    strm.next_in = (Bytef *)[self bytes];
    strm.avail_in = (uInt)[self length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    
    if (inflateInit (&strm) != Z_OK) return nil;
    
    while (!done)
    {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length])
            [decompressed increaseLengthBy: half_length];
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = (uInt)([decompressed length] - strm.total_out);
        
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) done = YES;
        else if (status != Z_OK) break;
    }
    if (inflateEnd (&strm) != Z_OK) return nil;
    
    // Set real length.
    if (done)
    {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    }
    else return nil;
}

- (NSData *)gzipCompress
{
    return [self gzipCompressWithLevel:MSCompressionLevelDefault];
}

- (NSData *)gzipCompressWithLevel:(MSCompressionLevel)level
{
    if ([self length] == 0) return self;
    
    z_stream strm;
    
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.total_out = 0;
    strm.next_in=(Bytef *)[self bytes];
    strm.avail_in = (uInt)[self length];
    
    // Compresssion Levels:
    //   Z_NO_COMPRESSION
    //   Z_BEST_SPEED
    //   Z_BEST_COMPRESSION
    //   Z_DEFAULT_COMPRESSION
    
    if (deflateInit2(&strm, level, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY) != Z_OK) return nil;
    
    NSMutableData *compressed = [NSMutableData dataWithLength:16384];  // 16K chunks for expansion
    
    do {
        
        if (strm.total_out >= [compressed length])
            [compressed increaseLengthBy: 16384];
        
        strm.next_out = [compressed mutableBytes] + strm.total_out;
        strm.avail_out = (uInt)([compressed length] - strm.total_out);
        
        deflate(&strm, Z_FINISH);
        
    } while (strm.avail_out == 0);
    
    deflateEnd(&strm);
    
    [compressed setLength: strm.total_out];
    return [NSData dataWithData:compressed];
}

- (NSData *)gzipDecompress
{
    if ([self length] == 0) return self;
    
    NSUInteger full_length = [self length];
    NSUInteger half_length = [self length] / 2;
    
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    
    z_stream strm;
    strm.next_in = (Bytef *)[self bytes];
    strm.avail_in = (uInt)[self length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    
    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
    while (!done)
    {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length])
            [decompressed increaseLengthBy: half_length];
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = (uInt)([decompressed length] - strm.total_out);
        
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) done = YES;
        else if (status != Z_OK) break;
    }
    if (inflateEnd (&strm) != Z_OK) return nil;
    
    // Set real length.
    if (done)
    {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    }
    else return nil;
}

#if !TARGET_OS_IPHONE

- (NSData *)bzipCompress
{
    return [self bzipCompressWithLevel:MSCompressionLevelDefault];
}

- (NSData *)bzipCompressWithLevel:(MSCompressionLevel)level
{
    int bzret, buffer_size = 1000000;
    bz_stream stream = { 0 };
    stream.next_in = (char*)[self bytes];
    stream.avail_in = (unsigned)[self length];
    if (level < 0)
        level = 6;
    
    NSMutableData * buffer = [NSMutableData dataWithLength:buffer_size];
    stream.next_out = [buffer mutableBytes];
    stream.avail_out = buffer_size;
    
    NSMutableData * compressed = [NSMutableData data];
    
    BZ2_bzCompressInit(&stream, level, 0, 0);
    @try {
        do {
            bzret = BZ2_bzCompress(&stream, (stream.avail_in) ? BZ_RUN : BZ_FINISH);
            if (bzret != BZ_RUN_OK && bzret != BZ_STREAM_END)
                @throw [NSException exceptionWithName:@"bzip2" reason:@"BZ2_bzCompress failed" userInfo:nil];
            
            [compressed appendBytes:[buffer bytes] length:(buffer_size - stream.avail_out)];
            stream.next_out = [buffer mutableBytes];
            stream.avail_out = buffer_size;
        } while(bzret != BZ_STREAM_END);
    }
    @finally {
        BZ2_bzCompressEnd(&stream);
    }
    
    return [NSData dataWithData:compressed];
}

- (NSData *)bzipDecompress
{
    int bzret;
    bz_stream stream = { 0 };
    stream.next_in = (char*)[self bytes];
    stream.avail_in = (unsigned)[self length];
    
    const int buffer_size = 10000;
    NSMutableData * buffer = [NSMutableData dataWithLength:buffer_size];
    stream.next_out = [buffer mutableBytes];
    stream.avail_out = buffer_size;
    
    NSMutableData * decompressed = [NSMutableData data];
    
    BZ2_bzDecompressInit(&stream, 0, NO);
    @try {
        do {
            bzret = BZ2_bzDecompress(&stream);
            if (bzret != BZ_OK && bzret != BZ_STREAM_END)
                @throw [NSException exceptionWithName:@"bzip2" reason:@"BZ2_bzDecompress failed" userInfo:nil];
            
            [decompressed appendBytes:[buffer bytes] length:(buffer_size - stream.avail_out)];
            stream.next_out = [buffer mutableBytes];
            stream.avail_out = buffer_size;
        } while(bzret != BZ_STREAM_END);
    }
    @finally {
        BZ2_bzDecompressEnd(&stream);
    }
    
    return [NSData dataWithData:decompressed];
}

#endif

@end
