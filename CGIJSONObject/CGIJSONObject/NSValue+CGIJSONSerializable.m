//
//  NSValue+CGIJSONSerializable.m
//  CGIJSONObject
//
//  Created by Maxthon Chan on 9/18/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "NSObject+CGIJSONSerializable.h"
#import <MSBooster/MSBooster_Private.h>

MSConstantString(CGIValueDataKey, data);
MSConstantString(CGIValueTypeKey, type);

@implementation NSValue (CGIJSONSerializable)

- (id)initWithSerializedObject:(id)serializedObject
{
    if ([serializedObject isKindOfClass:[NSNumber class]])
    {
        self = nil;
        return serializedObject;
    }
    else if ([serializedObject isKindOfClass:[NSDictionary class]])
    {
        NSData *data = [[NSData alloc] initWithSerializedObject:serializedObject[CGIValueDataKey]];
        NSString *type = serializedObject[CGIValueTypeKey];
        return self = [self initWithBytes:[data bytes]
                                 objCType:[type cStringUsingEncoding:[NSString defaultCStringEncoding]]];
    }
    else
    {
        return self = nil;
    }
}

- (id)serializedObject
{
    NSUInteger size = 0;
    const char *type = [self objCType];
    NSGetSizeAndAlignment(type,
                          &size,
                          NULL);
    void *data = malloc(size);
    if (!data)
        return nil;
    [self getValue:data];
    
    return @{CGIValueTypeKey: @(type),
             CGIValueDataKey: [NSData dataWithBytesNoCopy:data
                                                   length:size
                                             freeWhenDone:YES]};
}

- (BOOL)setSerializedObject:(id)serializedObject
{
    return NO;
}

@end
