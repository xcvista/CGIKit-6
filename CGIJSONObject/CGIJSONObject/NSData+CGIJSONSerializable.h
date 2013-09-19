//
//  NSData+Base64.h
//  base64
//
//  Created by Matt Gallagher on 2009/06/03.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software. Permission is granted to anyone to
//  use this software for any purpose, including commercial applications, and to
//  alter it and redistribute it freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source
//     distribution.
//

#import <Foundation/Foundation.h>

void *NewBase64Decode(
                      const char *inputBuffer,
                      size_t length,
                      size_t *outputLength);

char *NewBase64Encode(
                      const void *inputBuffer,
                      size_t length,
                      bool separateLines,
                      size_t *outputLength);

@interface NSData (Base64)

/// Get the data from a Base-64 encoded string.
+ (NSData *)dataFromBase64String:(NSString *)aString;

/// Initialize the data from a Base-64 encoded string.
- (id)initWithBase64String:(NSString *)aString;

/// Get the Base-64 encoded string representation of current data object.
- (NSString *)base64EncodedString;

// added by Hiroshi Hashiguchi

/**
 Get the Base-64 encoded string representation of current data object.
 
 @param     separateLines   Whether the 76-character seperation is used.
 */
- (NSString *)base64EncodedStringWithSeparateLines:(BOOL)separateLines;

@end
