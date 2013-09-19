//
//  NSObject+CGIJSONSerializing.h
//  CGIJSONObject
//
//  Created by Maxthon Chan on 8/30/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CGIJSONSerializing)

/**
 Initialize an object from serialized JSON data.
 */
- (id)initWithJSONData:(NSData *)data error:(out NSError **)error;

/**
 Check if an object can be JSON serialized.
 */
- (BOOL)canJSONSerialize;

/**
 Get the object in its JSON serialized form.
 */
- (NSData *)JSONDataWithWritingOptions:(NSJSONWritingOptions)options error:(out NSError **)error;

@end
