//
//  NSObject+CGIJSONSerializing.h
//  CGIJSONObject
//
//  Created by Maxthon Chan on 8/30/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CGIJSONSerializing)

- (id)initWithJSONData:(NSData *)data error:(NSError **)error;

- (BOOL)canJSONSerialize;
- (NSData *)JSONDataWithWritingOptions:(NSJSONWritingOptions)options error:(NSError **)error;

@end
