//
//  CGIHostAddress.m
//  CGISocket
//
//  Created by Maxthon Chan on 10/10/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "CGIHostAddress.h"

@implementation CGIHostAddress

- (struct sockaddr *)address
{
    return _address;
}

- (socklen_t)size
{
    return _size;
}

- (NSData *)addressData
{
    return [NSData dataWithBytes:_address length:_size];
}

@end
