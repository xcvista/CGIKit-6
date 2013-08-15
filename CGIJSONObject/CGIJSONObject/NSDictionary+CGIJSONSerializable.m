//
//  NSDictionary+CGIJSONSerializable.m
//  CGIJSONObject
//
//  Created by Maxthon Chan on 8/15/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "NSObject+CGIJSONSerializable.h"

@implementation NSDictionary (CGIJSONSerializable)

- (id)initWithSerializedObject:(id)serializedObject
{
    return self = ([serializedObject isKindOfClass:[NSDictionary class]]) ? [self initWithDictionary:serializedObject] : nil;
}

- (id)serializedObject
{
    NSMutableDictionary *output = [NSMutableDictionary dictionaryWithCapacity:[self count]];
    
    for (id key in self)
    {
        if ([key isKindOfClass:[NSString class]])
        {
            output[key] = [self[key] serializedObject];
        }
        else
        {
            return nil;
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:output];
}

@end
