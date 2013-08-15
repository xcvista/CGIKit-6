//
//  NSDate+CGIJSONSerializable.m
//  CGIJSONObject
//
//  Created by Maxthon Chan on 8/15/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "NSObject+CGIJSONSerializable.h"
#import <MSBooster/MSBooster.h>

@implementation NSDate (CGIJSONSerializable)

- (id)initWithSerializedObject:(id)serializedObject
{
    if ([serializedObject isKindOfClass:[NSString class]])
    {
        long long time = [serializedObject longLongValue];
        NSTimeInterval interval = time / 1000.0;
        return self = [self initWithTimeIntervalSince1970:interval];
    }
    else
        return self = nil;
}

- (id)serializedObject
{
    NSTimeInterval interval = [self timeIntervalSince1970];
    long long time = interval * 1000.0 + 0.5;
    return MSSTR(@"%lld", time);
}

- (BOOL)setSerializedObject:(id)serializedObject
{
    return NO;
}

@end
