//
//  NSDate+CGIJSONSerializable.m
//  CGIJSONObject
//
//  Created by Maxthon Chan on 8/15/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "NSDate+CGIJSONSerializable.h"
#import "NSObject+CGIJSONSerializable.h"
#import <MSBooster/MSBooster.h>

static CGIDateEmitDataType _CGI_DateEmitDataType;

@implementation NSDate (CGIJSONSerializable)

- (id)initWithSerializedObject:(id)serializedObject
{
    if ([serializedObject respondsToSelector:@selector(longLongValue)])
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
    return (_CGI_DateEmitDataType == CGIDateEmitString) ? MSSTR(@"%lld", time) : @(time);
}

- (BOOL)setSerializedObject:(id)serializedObject
{
    return NO;
}

@end

@implementation NSDate (CGIJSONSerializableEmittingType)

+ (void)load
{
#ifdef GNUSTEP
    _CGI_DateEmitDataType = CGIDateEmitString;
#else
    _CGI_DateEmitDataType = CGIDateEmitNumber;
#endif
}

+ (CGIDateEmitDataType)emitDataType
{
    return _CGI_DateEmitDataType;
}

+ (void)setEmitDataType:(CGIDateEmitDataType)dataType
{
    _CGI_DateEmitDataType = dataType;
}

@end
