//
//  NSNull+CGIJSONSerializable.m
//  CGIJSONObject
//
//  Created by Maxthon Chan on 8/15/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "NSObject+CGIJSONSerializable.h"

@implementation NSNull (CGIJSONSerializable)

- (id)initWithSerializedObject:(id)serializedObject
{
    self = nil;
    return ([serializedObject isKindOfClass:[NSNull class]]) ? [NSNull null] : nil;
}

- (id)serializedObject
{
    return [NSNull null];
}

- (BOOL)setSerializedObject:(id)serializedObject
{
    return NO;
}

@end
