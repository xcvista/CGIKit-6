//
//  NSString+CGIJSONSerialization.m
//  CGIJSONObject
//
//  Created by Maxthon Chan on 8/15/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "NSObject+CGIJSONSerializable.h"

@implementation NSString (CGIJSONSerializable)

- (id)initWithSerializedObject:(id)serializedObject
{
    return self = ([serializedObject isKindOfClass:[NSString class]]) ? [self initWithString:serializedObject] : nil;
}

- (id)serializedObject
{
    return self;
}

@end
