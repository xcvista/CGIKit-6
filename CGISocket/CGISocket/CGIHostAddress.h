//
//  CGIHostAddress.h
//  CGISocket
//
//  Created by Maxthon Chan on 10/10/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/socket.h>

@interface CGIHostAddress : NSObject
{
    struct sockaddr *_address;
    socklen_t _size;
}

- (struct sockaddr *)address;
- (socklen_t)size;

- (NSData *)addressData;

- (id)initWithAddress:(struct sockaddr *)address size:(socklen_t)size;

@end
