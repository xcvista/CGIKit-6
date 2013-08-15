//
//  NSNumber+CGIJSONSerializable.m
//  CGIJSONObject
//
//  Created by Maxthon Chan on 8/15/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "NSObject+CGIJSONSerializable.h"

@implementation NSNumber (CGIJSONSerializable)

- (id)initWithSerializedObject:(id)serializedObject
{
    self = nil;
    return ([serializedObject isKindOfClass:[NSNumber class]]) ? serializedObject : nil;
}

- (id)serializedObject
{
    return self;
}

- (BOOL)setSerializedObject:(id)serializedObject
{
    return NO;
}

@end
