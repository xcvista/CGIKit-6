//
//  NSObject+CGIJSONSerializing.m
//  CGIJSONObject
//
//  Created by Maxthon Chan on 8/30/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "NSObject+CGIJSONSerializing.h"
#import "NSObject+CGIJSONSerializable.h"

@implementation NSObject (CGIJSONSerializing)

- (id)initWithJSONData:(NSData *)data error:(NSError *__autoreleasing *)error
{
    id object = [NSJSONSerialization JSONObjectWithData:data
                                                options:0
                                                  error:error];
    if (!object)
        return self = nil;
    return [self initWithSerializedObject:object];
}

- (BOOL)canJSONSerialize
{
    return [NSJSONSerialization isValidJSONObject:[self serializedObject]];
}

- (NSData *)JSONDataWithWritingOptions:(NSJSONWritingOptions)options error:(NSError *__autoreleasing *)error
{
    return [NSJSONSerialization dataWithJSONObject:[self serializedObject]
                                           options:options
                                             error:error];
}

@end
