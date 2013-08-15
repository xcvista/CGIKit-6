//
//  NSArray+CGIJSONSerializable.m
//  CGIJSONObject
//
//  Created by Maxthon Chan on 8/15/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "NSArray+CGIJSONSerializable.h"
#import "NSObject+CGIJSONSerializable.h"

@implementation NSArray (CGIJSONSerializableHelper)

- (id)initWithArray:(NSArray *)array classForMembers:(Class)class
{
    NSMutableArray *output = [NSMutableArray arrayWithCapacity:[array count]];
    for (id encodedObject in array)
    {
        id object = nil;
        if ([encodedObject isKindOfClass:[NSArray class]])
        {
            object = [[NSArray alloc] initWithArray:encodedObject
                                    classForMembers:class];
        }
        else
        {
            object = [[class alloc] initWithSerializedObject:encodedObject];
        }
        
        if (!object)
            object = encodedObject;
        
        [output addObject:object];
    }
    
    return [self initWithArray:output];
}

@end

@implementation NSArray (CGIJSONSerializable)

- (id)initWithSerializedObject:(id)serializedObject
{
    self = nil;
    return ([serializedObject isKindOfClass:[NSArray class]]) ? serializedObject : nil;
}

- (id)serializedObject
{
    NSMutableArray *output = [NSMutableArray arrayWithCapacity:[self count]];
    for (id object in self)
    {
        [output addObject:[object serializedObject]];
    }
    return [NSArray arrayWithArray:output];
}

@end
