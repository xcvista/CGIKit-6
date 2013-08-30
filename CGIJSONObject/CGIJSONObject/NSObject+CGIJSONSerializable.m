//
//  NSObject+CGIJSONSerializable.m
//  CGIJSONObject
//
//  Created by Maxthon Chan on 8/15/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "NSObject+CGIJSONSerializable.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <MSBooster/MSBooster.h>
#import "NSArray+CGIJSONSerializable.h"

#pragma mark - Default class marker

@interface _CGI_DefaultClassMarker : NSObject

@end

@implementation _CGI_DefaultClassMarker

- (id)initWithSerializedObject:(id)serializedObject
{
    self = nil;
    return serializedObject;
}

- (id)serializedObject
{
    return nil;
}

- (NSArray *)allKeys
{
    return @[];
}

- (Class)classForKey:(NSString *)key
{
    return Nil;
}

@end

@implementation NSObject (CGIJSONSerializable)

- (id)initWithSerializedObject:(id)serializedObject
{
    if (self = [self init])
    {
        if (![self setSerializedObject:serializedObject])
        {
            self = nil;
        }
    }
    return self;
}

- (id)serializedObject
{
    NSArray *keys = [self allKeys];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:[keys count]];
    
    for (NSString *key in keys)
    {
        id value = [self valueForKey:key];
        if (!value)
            value = [NSNull null];
        if ([self classForKey:key])
        {
            NSString *_key = [self serializationKeyForKey:key];
            if (!_key)
                _key = key;
            dict[_key] = [value serializedObject];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

- (BOOL)setSerializedObject:(id)serializedObject
{
    NSDictionary *dict = nil;
    if ([serializedObject isKindOfClass:[NSDictionary class]])
    {
        dict = serializedObject;
    }
    else
    {
        return NO;
    }
    
    for (NSString *_key in [self allKeys])
    {
        NSString *key = [self serializationKeyForKey:_key];
        if (!key)
            key = _key;
        
        Class class = [self classForKey:_key];
        if (class)
        {
            id encodedObject = dict[key];
            id object = nil;
            if ([encodedObject isKindOfClass:[NSArray class]])
            {
                Class propertyClass = [self classForProperty:key];
                if (![propertyClass isSubclassOfClass:[NSArray class]])
                    propertyClass = [NSArray class];
                
                object = [[propertyClass alloc] initWithArray:encodedObject
                                              classForMembers:class];
            }
            else if ([object isKindOfClass:[NSNull class]])
            {
                object = nil;
            }
            else
            {
                object = [[class alloc] initWithSerializedObject:encodedObject];
            }
            
            if (object)
            {
                [self setValue:object forKey:_key];
            }
        }
    }
    return YES;
}

- (NSArray *)allKeys
{
    unsigned propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    NSMutableArray *allKeys = [NSMutableArray arrayWithCapacity:propertyCount];
    
    for (unsigned i = 0; i < propertyCount; i++)
    {
        objc_property_t property = properties[i];
        [allKeys addObject:@(property_getName(property))];
    }
    
    return [NSArray arrayWithArray:allKeys];
}

- (Class)classForKey:(NSString *)key
{
    SEL classRequest = NSSelectorFromString(MSSTR(@"classForKey%@", key));
    if ([self respondsToSelector:classRequest])
    {
        return objc_msgSend(self, classRequest);
    }
    else
    {
        return [self classForProperty:key];
    }
}

- (Class)classForProperty:(NSString *)key
{
    objc_property_t property = class_getProperty([self class], [key UTF8String]);
    NSArray *attributes = [@(property_getAttributes(property)) componentsSeparatedByString:@","];
    NSString *className = NSStringFromClass([_CGI_DefaultClassMarker class]);
    for (NSString *attribute in attributes)
    {
        if ([attribute hasPrefix:@"T"])
        {
            unichar ch = [attribute characterAtIndex:1];
            if (ch == '@' && [attribute length] > 4)
            {
                className = [attribute substringWithRange:NSMakeRange(3, [attribute length] - 4)];
            }
            else
            {
                className = NSStringFromClass([NSNumber class]);
            }
        }
    }
    return NSClassFromString(className);
}

- (NSString *)serializationKeyForKey:(NSString *)key
{
    return key;
}

@end
