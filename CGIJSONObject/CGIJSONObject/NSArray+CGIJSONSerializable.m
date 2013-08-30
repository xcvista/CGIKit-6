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
            object = [[[self class] alloc] initWithArray:encodedObject
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
    return ([serializedObject isKindOfClass:[NSArray class]]) ? [self initWithArray:serializedObject] : nil;
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

- (BOOL)setSerializedObject:(id)serializedObject
{
    return NO;
}

@end

@implementation NSMutableArray (CGIJSONSerializable)

- (BOOL)setSerializedObject:(id)serializedObject
{
    if ([serializedObject isKindOfClass:[NSArray class]])
    {
        [self setArray:serializedObject];
        return YES;
    }
    else
        return NO;
}

@end
